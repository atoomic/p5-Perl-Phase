use Test::Spec;
use Perl::Phase;

diag("Testing Perl::Phase $Perl::Phase::VERSION");

# TODO: populate these test, ${^GLOBAL_PHASE} is read-only so its not as simple as local ${^GLOBAL_PHASE} = '…';
describe "Perl::Phase function" => sub {
    describe "run time function" => sub {
        describe "is_run_time()" => sub {
            it "should be true (stage name) during INIT";
            it "should be true (stage name) during RUN";
            it "should be true (stage name) during END";
            it "should be treu (stage name) during DESTRUCT";
            it "should be false otherwise";
        };

        describe "assert_is_run_time()" => sub {
            it "should not die during run time" => sub {
                no warnings "redefine";
                local *Perl::Phase::is_run_time = sub { 1 };
                trap { Perl::Phase::assert_is_run_time() };
                is $trap->die, undef;

            };
            it "should die during compile time" => sub {
                no warnings "redefine";
                local *Perl::Phase::is_run_time = sub { 0 };
                trap { Perl::Phase::assert_is_run_time() };
                like $trap->die, qr/at compile time/;
            };
        };
    };

    describe "compile time function" => sub {
        describe "is_compile_time()" => sub {
            it "should be true (stage name) during CONSTRUCT";
            it "should be true (stage name) during START";
            it "should be true (stage name) during CHECK";
            it "should be false otherwise";
        };

        describe "assert_is_compile_time()" => sub {
            it "should not die during compile time" => sub {
                no warnings "redefine";
                local *Perl::Phase::is_compile_time = sub { 1 };
                trap { Perl::Phase::assert_is_compile_time() };
                is $trap->die, undef;

            };
            it "should die during compile time" => sub {
                no warnings "redefine";
                local *Perl::Phase::is_compile_time = sub { 0 };
                trap { Perl::Phase::assert_is_compile_time() };
                like $trap->die, qr/at run time/;
            };
        };
    };
};

runtests unless caller;
