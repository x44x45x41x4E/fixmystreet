use utf8;
package FixMyStreet::DB::Result::ModerationOriginalData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("FilterColumn", "InflateColumn::DateTime", "EncodedColumn");
__PACKAGE__->table("moderation_original_data");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "moderation_original_data_id_seq",
  },
  "problem_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "comment_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "detail",
  { data_type => "text", is_nullable => 1 },
  "photo",
  { data_type => "bytea", is_nullable => 1 },
  "anonymous",
  { data_type => "boolean", is_nullable => 0 },
  "created",
  {
    data_type     => "timestamp",
    default_value => \"ms_current_timestamp()",
    is_nullable   => 0,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("moderation_original_data_comment_id_key", ["comment_id"]);
__PACKAGE__->belongs_to(
  "comment",
  "FixMyStreet::DB::Result::Comment",
  { id => "comment_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);
__PACKAGE__->belongs_to(
  "problem",
  "FixMyStreet::DB::Result::Problem",
  { id => "problem_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2014-07-31 15:59:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yR1Vi7cJQrX67dFwAcJW6w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
