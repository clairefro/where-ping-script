#!/usr/bin/perl

use strict;
use warnings;
use HTTP::Tiny;
use JSON;
use File::Spec;
use File::Basename;

# Get the directory of the current script
my $script_dir = dirname(__FILE__);

# Define the relative path (vars.txt should be in same dir as this script file)
my $relative_path = 'vars.txt';

# Construct the absolute path using string interpolation
my $absolute_path = File::Spec->rel2abs("$script_dir/$relative_path");

# ----- LOAD VARIABLES ---- 

# Open the file for reading
open my $fh, '<', $absolute_path or die "Cannot open file '$absolute_path' for reading: $!";

# Initialize a hash to store variables
my %variables;

# Read each line from the file
while (my $line = <$fh>) {
    chomp $line;

    # Skip comments and empty lines
    next if $line =~ /^\s*#/ || $line =~ /^\s*$/;

    # Split the line into variable and value
    my ($variable, $value) = split /\s*=\s*/, $line, 2;

    # Store the variable and its value in the hash
    $variables{$variable} = $value;
}

# Close the file handle
close $fh;

# -----------------------


my $IPINFO_TOKEN = $variables{'ipinfo_token'};
my $SERVER_URL = $variables{'server_url'};
my $TOKEN = $variables{'token'};


# Fetch data from ipinfo.io
my $http = HTTP::Tiny->new;
my $response = $http->get("https://ipinfo.io/?token=$IPINFO_TOKEN");

# Check if the request was successful
if ($response->{success}) {
    my $content = $response->{content};
    print "Latest ping: $content\n";

    # Send data to the server
    my $response = $http->post(
        $SERVER_URL,
        {
            content => $content,
            headers => {
                'Content-Type' => 'application/json',
                'Authorization' => "Bearer $TOKEN"
            },
        }
    );

    # Check if the server request was successful
    if ($response->{success}) {
        print "Data sent to the server successfully: $response->{content}\n";
    } else {
        print "Failed to send data to the server: $response->{content}\n";
    }
} else {
    print "Failed to fetch data from ipinfo.io\n";
}
