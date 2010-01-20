use inc::Module::Install;
name 'DBIx-Skinny-Mixin-UpdateOrCreate';
all_from 'lib/DBIx/Skinny/Mixin/UpdateOrCreate.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
