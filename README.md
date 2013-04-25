# NAME

Net::Groonga::HTTP - It's new $module

# SYNOPSIS

    use Net::Groonga::HTTP;

    my $groonga = Net::Groonga::HTTP->new(
        end_point => 'http://127.0.0.1:10041/d/',
    );
    my $res = $groonga->status();
    use Data::Dumper; warn Dumper($res);



# DESCRIPTION

Net::Groonga::HTTP is ...

# LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokuhirom <tokuhirom@gmail.com>
