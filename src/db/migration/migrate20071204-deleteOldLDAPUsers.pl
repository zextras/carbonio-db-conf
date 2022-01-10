#!/usr/bin/perl

# SPDX-FileCopyrightText: 2021 Synacor, Inc.
# SPDX-FileCopyrightText: 2021 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-License-Identifier: GPL-2.0-only

use strict;
use Net::LDAPapi;

my ($binddn,$bindpwd,$host,$junk,$result,@localconfig,$ismaster);
@localconfig=`/opt/zextras/bin/zmlocalconfig -s ldap_master_url zimbra_ldap_userdn zimbra_ldap_password ldap_is_master`;
$host=$localconfig[0];
($junk,$host) = split /= /, $host, 2;
chomp $host;

$binddn=$localconfig[1];
($junk,$binddn) = split /= /, $binddn, 2;
chomp $binddn;

$bindpwd=$localconfig[2];
($junk,$bindpwd) = split /= /, $bindpwd, 2;
chomp $bindpwd;

$ismaster=$localconfig[3];
($junk,$ismaster) = split /= /, $ismaster, 2;
chomp $ismaster;

if ($ismaster ne "true") {
  exit;
}

print "Deleting old LDAP users\n";
my $ld = Net::LDAPapi->new(-url=>"$host");
my $status;

if ($host !~ /^ldaps/i) {
  $status=$ld->start_tls_s();
}

$status = $ld->bind_s($binddn,$bindpwd);

$status = $ld->delete_s("uid=zimbrareplication,cn=admins,cn=zimbra");
$status = $ld->delete_s("uid=zmpostfix,cn=admins,cn=zimbra");
$status = $ld->delete_s("uid=zmamavis,cn=admins,cn=zimbra");

$ld->unbind();

print "done.\n";
