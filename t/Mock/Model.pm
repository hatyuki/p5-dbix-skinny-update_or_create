package Mock::Model;

use DBIx::Skinny setup => {
    dsn      => 'dbi:SQLite:',
    username => '',
    password => '',
};
use DBIx::Skinny::Mixin modules => [qw/ UpdateOrCreate /];


sub setup
{
    my $self = shift;

    $self->do(q/
        CREATE TABLE mock (
        id      INTEGER PRIMARY KEY,
        name    TEXT NOT NULL,
        comment TEXT
        )
    /);

    $self->insert(mock => {
        id      => 1,
        name    => 'name1',
        comment => 'comment1',
    });

    $self->insert(mock => {
        id      => 2,
        name    => 'name2',
        comment => 'comment2',
    });

    $self->insert(mock => {
        id      => 3,
        name    => 'duplicate',
        comment => 'comment3',
    });

    $self->insert(mock => {
        id      => 4,
        name    => 'duplicate',
        comment => 'comment4',
    });

    return $self;
}


{
    package Mock::Model::Schema;
    use DBIx::Skinny::Schema;

    install_table mock => schema {
        pk 'id';
        columns qw/ id name comment /;
    };
}


1;
