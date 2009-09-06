#!/usr/bin/env perl
use inc::Module::Install;

name "Yesh";
all_from "lib/Yesh.pm";

requires "Catalyst::Runtime" => "5.80007";
requires "Catalyst::Plugin::ConfigLoader";
requires "Catalyst::Plugin::Static::Simple";
requires "Catalyst::Action::RenderView";
requires "Catalyst::Controller::REST";
requires "parent";
requires "YAML";
requires "DBIx::Class" => 0.081;
requires "DBIx::Class::EncodedColumn";
requires "Crypt::Eksblowfish::Bcrypt";
requires "JSON::XS";
requires "XML::LibXML";
requires "URI";
requires "CatalystX::Plugin::Blurb";
requires "DateTime::Format::SQLite";

# requires "URI::QueryParam";

test_requires "HTTP::Request::Common";

catalyst;

if ( $Module::Install::AUTHOR )
{
    system("pod2text lib/Yesh.pm > README") == 0
        or die "Couldn't update the README";
}

install_script glob("script/*.pl");
auto_install;
WriteAll;

__END__

# requires "Catalyst::Authentication::Realm::SimpleDB";
