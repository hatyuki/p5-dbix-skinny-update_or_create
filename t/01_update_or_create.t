use strict;
use warnings;
use lib './t';
use Test::More;
use Mock::Model;


my $model = Mock::Model->new->setup;


do {
    my $row = $model->update_or_create(
        mock => { id => 1 }, { name => 'replace' }
    );

    isa_ok $row, 'DBIx::Skinny::Row'; 
    is_deeply $row->get_columns, {
        id      => 1,
        name    => 'replace',
        comment => 'comment1',
    };
    ok $model->in_storage;
};

do {
    my $row = $model->update_or_create(
        mock => { name => 'replace', comment => 'comment1' }, { comment => 'foo' },
    );

    is_deeply $row->get_columns, {
        id      => 1,
        name    => 'replace',
        comment => 'foo',
    };
    ok $model->in_storage;
};

do {
    my $row = $model->update_or_create(
        mock => { id => 2 }, { id => 5 },
    );

    is_deeply $row->get_columns, {
        id      => 5,
        name    => 'name2',
        comment => 'comment2',
    };
    ok $model->in_storage;
};

do {
    my $row = $model->update_or_create(
        mock => { id => 10 }, { name => 'name10', comment => 'comment10' }
    );

    is_deeply $row->get_columns, {
        id      => 10,
        name    => 'name10',
        comment => 'comment10',
    };
    ok !$model->in_storage;
};

do {
    my $row = $model->update_or_create(
        mock => { name => 'duplicate', comment => 'comment3' }, { comment => 'baz' },
    );

    is_deeply $row->get_columns, {
        id      => 3,
        name    => 'duplicate',
        comment => 'baz',
    };
    ok $model->in_storage;
};

do {
    local $SIG{__WARN__} = sub {
        my $warn = shift;
        like $warn, qr/Could not update; Query returned more than one row/;
    };

    my $row = $model->update_or_create(
        mock => { name => 'duplicate' }, { comment => 'exception' },
    );

    ok !$row;
};


done_testing;
