package TestMLBridge;
use base 'TestML::Bridge';

use XXX;

use YAML::PP;
use YAML::PP::Parser;
use YAML::PP::Emitter;
use YAML::PP::Writer;

our @output;

my $parser = YAML::PP::Parser->new(
  receiver => sub {
    my ($self, @args) = @_;
    push @output, YAML::PP::Parser->event_to_test_suite(\@args);
  },
);

sub yaml_load {
    my ($self, $yaml) = @_;

    $yaml =~ s/<SPC>/ /g;
    $yaml =~ s/<TAB>/\t/g;

    return YAML::PP->new->load_string($yaml);
}

sub to_events {
    my ($self, $yaml) = @_;

    $parser->parse($yaml);

    join "\n", @output, '';
}

sub yaml_emit {
    my ($self, $input, $style) = @_;
    my $emitter = YAML::PP::Emitter->new();

    my $yp = YAML::PP->new( schema => ['Failsafe'] );

    my $writer = YAML::PP::Writer->new;

    $emitter->init;
    $emitter->set_writer($writer);
    $emitter->stream_start_event;
    $emitter->document_start_event({ implicit => 1 });
    $emitter->sequence_start_event;
    $emitter->scalar_event({ value => $input, style => $style });
    $emitter->sequence_end_event;
    $emitter->document_end_event({ implicit => 1 });
    $emitter->stream_end_event;

    my $yaml = $emitter->writer->output;
    my $data = $yp->load_string($yaml);

    return $data->[0];
}

1;
