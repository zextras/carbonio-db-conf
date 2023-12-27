#!/usr/bin/perl

# SPDX-FileCopyrightText: 2021 Synacor, Inc.
# SPDX-FileCopyrightText: 2021 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: GPL-2.0-only
# SPDX-License-Identifier: GPL-2.0-only

use strict;
use lib "/opt/zextras/common/lib/perl5";
use Zimbra::Util::Common;
use Data::UUID;
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

my @attrs=("zimbraPrefMailSignature", "zimbraPrefIdentityName");

print "Beginning identity migration";
my $ld = Net::LDAPapi->new(-url=>"$host");
my $status;
if ($host !~ /^ldaps/i) {
  $status=$ld->start_tls_s();
}
$status = $ld->bind_s($binddn,$bindpwd);
$status = $ld->search_s("",LDAP_SCOPE_SUBTREE,"(&(!(zimbraSignatureID=*))(zimbraPrefMailSignature=*))",\@attrs,0,$result);

my ($ent,$dn,$sigRdn,$sigContent,$rdn, $rdnValue, $ug, $sigId, $sigName, $sigDN, $baseDN);

for ($ent = $ld->first_entry; $ent != 0; $ent = $ld->next_entry) {
	#
	#  Get Full DN
	if (($dn = $ld->get_dn) eq "")
	{
		$ld->unbind;
		die "get_dn: ", $ld->errstring, ": ", $ld->extramsg;
	}
	($rdn, $sigName) = split /,/, $dn, 2;
	($rdn, $sigName) = split /=/, $rdn, 2;

	#$attr = $ld->first_attribute;
	$sigContent=($ld->get_values("zimbraPrefMailSignature"))[0];
	$sigRdn=($ld->get_values("zimbraPrefIdentityName"))[0];
	$ug = Data::UUID->new;
	$sigId = $ug->create_str();

	if ($rdn eq "uid") {
		$sigDN = $dn;
	}
	else {
		($junk,$baseDN) = split /,/, $dn, 2;
		$sigDN = "zimbraSignatureName=".$sigName.",".$baseDN;
	}
  
	my %ldap_modifications;
	if ($rdn eq "uid" ) {
		%ldap_modifications = (
			"zimbraSignatureId", "$sigId",
			"zimbraSignatureName", "$sigRdn",
		);
		$ld->modify_s($sigDN,\%ldap_modifications);	
	} else {
		%ldap_modifications = (
			"zimbraSignatureName", "$sigRdn",
			"objectClass", "zimbraSignature",
			"zimbraSignatureId", "$sigId",
			"zimbraPrefMailSignature", "$sigContent",
		);
		$ld->add_s($sigDN,\%ldap_modifications);
	}
	%ldap_modifications = (
		"zimbraPrefDefaultSignatureId", "$sigId",
	);
	$ld->modify_s($dn,\%ldap_modifications);
	print ".";
}
print " done!\n";

$ld->unbind();
