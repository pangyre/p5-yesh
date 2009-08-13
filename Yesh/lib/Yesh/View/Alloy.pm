package Yesh::View::Alloy;
use strict;
use warnings;
no warnings "uninitialized";
use parent "Catalyst::View::TT::Alloy";

__PACKAGE__->config
    (
     ENCODING => 'UTF-8',
    );

1;
