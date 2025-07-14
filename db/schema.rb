# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_12_224937) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  create_table "action", id: :integer, default: nil, comment: "An action is something you can do, such as run a readwrite query", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the action was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the action was updated"
    t.text "type", null: false, comment: "Type of action"
    t.integer "model_id", null: false, comment: "The associated model"
    t.string "name", limit: 254, null: false, comment: "The name of the action"
    t.text "description", comment: "The description of the action"
    t.text "parameters", comment: "The saved parameters for this action"
    t.text "parameter_mappings", comment: "The saved parameter mappings for this action"
    t.text "visualization_settings", comment: "The UI visualization_settings for this action"
    t.string "public_uuid", limit: 36, comment: "Unique UUID used to in publically-accessible links to this Action."
    t.integer "made_public_by_id", comment: "The ID of the User who first publically shared this Action."
    t.integer "creator_id", comment: "The user who created the action"
    t.boolean "archived", default: false, null: false, comment: "Whether or not the action has been archived"
    t.string "entity_id", limit: 21, comment: "Random NanoID tag for unique identity."
    t.index ["creator_id"], name: "idx_action_creator_id"
    t.index ["made_public_by_id"], name: "idx_action_made_public_by_id"
    t.index ["model_id"], name: "idx_action_model_id"
    t.index ["public_uuid"], name: "idx_action_public_uuid"
    t.unique_constraint ["entity_id"], name: "action_entity_id_key"
    t.unique_constraint ["public_uuid"], name: "action_public_uuid_key"
  end

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_key", id: { type: :integer, comment: "The ID of the API Key itself", default: nil }, comment: "An API Key", force: :cascade do |t|
    t.integer "user_id", comment: "The ID of the user who this API Key acts as"
    t.string "key", limit: 254, null: false, comment: "The hashed API key"
    t.string "key_prefix", limit: 7, null: false, comment: "The first 7 characters of the unhashed key"
    t.integer "creator_id", null: false, comment: "The ID of the user that created this API key"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp when the key was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp when the key was last updated"
    t.string "name", limit: 254, null: false, comment: "The user-defined name of the API key."
    t.integer "updated_by_id", null: false, comment: "The ID of the user that last updated this API key"
    t.string "scope", limit: 64, comment: "The scope of the API key, if applicable"
    t.index ["creator_id"], name: "idx_api_key_created_by"
    t.index ["updated_by_id"], name: "idx_api_key_updated_by_id"
    t.index ["user_id"], name: "idx_api_key_user_id"
    t.unique_constraint ["key_prefix"], name: "api_key_key_prefix_key"
    t.unique_constraint ["name"], name: "api_key_name_key"
  end

  create_table "application_permissions_revision", id: :integer, default: nil, force: :cascade do |t|
    t.text "before", null: false
    t.text "after", null: false
    t.integer "user_id", null: false
    t.timestamptz "created_at", null: false
    t.text "remark"
    t.index ["user_id"], name: "idx_application_permissions_revision_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "class_session_id", null: false
    t.datetime "attended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_session_id"], name: "index_attendances_on_class_session_id"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "audit_log", id: :integer, default: nil, comment: "Used to store application events for auditing use cases", force: :cascade do |t|
    t.string "topic", limit: 32, null: false, comment: "The topic of a given audit event"
    t.timestamptz "timestamp", null: false, comment: "The time an event was recorded"
    t.timestamptz "end_timestamp", comment: "The time an event ended, if applicable"
    t.integer "user_id", comment: "The user who performed an action or triggered an event"
    t.string "model", limit: 32, comment: "The name of the model this event applies to (e.g. Card, Dashboard), if applicable"
    t.integer "model_id", comment: "The ID of the model this event applies to, if applicable"
    t.text "details", null: false, comment: "A JSON map with metadata about the event"
    t.index "(\nCASE\n    WHEN ((model)::text = 'Dataset'::text) THEN ('card_'::text || model_id)\n    WHEN (model_id IS NULL) THEN NULL::text\n    ELSE ((lower((model)::text) || '_'::text) || model_id)\nEND)", name: "idx_audit_log_entity_qualified_id"
  end

  create_table "bookmark_ordering", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "type", limit: 255, null: false
    t.integer "item_id", null: false
    t.integer "ordering", null: false
    t.index ["user_id"], name: "idx_bookmark_ordering_user_id"
    t.unique_constraint ["user_id", "ordering"], name: "unique_bookmark_user_id_ordering"
    t.unique_constraint ["user_id", "type", "item_id"], name: "unique_bookmark_user_id_type_item_id"
  end

  create_table "cache_config", id: { type: :integer, comment: "Unique ID", default: nil }, comment: "Cache Configuration", force: :cascade do |t|
    t.string "model", limit: 32, null: false, comment: "Name of an entity model"
    t.integer "model_id", null: false, comment: "ID of the said entity"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "Timestamp when the config was inserted"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "Timestamp when the config was updated"
    t.text "strategy", null: false, comment: "caching strategy name"
    t.text "config", null: false, comment: "caching strategy configuration"
    t.text "state", comment: "state for strategies needing to keep some data between runs"
    t.timestamptz "invalidated_at", comment: "indicates when a cache was invalidated last time for schedule-based strategies"
    t.timestamptz "next_run_at", comment: "keeps next time to run for schedule-based strategies"
    t.boolean "refresh_automatically", default: false, comment: "Whether or not we should automatically refresh cache results when a cache expires"

    t.unique_constraint ["model", "model_id"], name: "idx_cache_config_unique_model"
  end

  create_table "card_bookmark", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "card_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.index ["card_id"], name: "idx_card_bookmark_card_id"
    t.index ["user_id"], name: "idx_card_bookmark_user_id"
    t.unique_constraint ["user_id", "card_id"], name: "unique_card_bookmark_user_id_card_id"
  end

  create_table "card_label", id: :integer, default: nil, force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "label_id", null: false
    t.index ["card_id"], name: "idx_card_label_card_id"
    t.index ["label_id"], name: "idx_card_label_label_id"
    t.unique_constraint ["card_id", "label_id"], name: "unique_card_label_card_id_label_id"
  end

  create_table "channel", id: { type: :integer, comment: "Unique ID", default: nil }, comment: "Channel configurations", force: :cascade do |t|
    t.string "name", limit: 254, null: false, comment: "channel name"
    t.text "description", comment: "channel description"
    t.string "type", limit: 32, null: false, comment: "Channel type"
    t.text "details", null: false, comment: "Channel details, used to store authentication information or channel-specific settings"
    t.boolean "active", default: true, null: false, comment: "whether the channel is active"
    t.timestamptz "created_at", null: false, comment: "Timestamp when the channel was inserted"
    t.timestamptz "updated_at", null: false, comment: "Timestamp when the channel was updated"

    t.unique_constraint ["name"], name: "channel_name_key"
  end

  create_table "channel_template", id: :integer, default: nil, comment: "custom template for the channel", force: :cascade do |t|
    t.string "name", limit: 64, null: false, comment: "the name of the template"
    t.string "channel_type", limit: 64, null: false, comment: "the channel type of the template"
    t.text "details", comment: "the details of the template"
    t.timestamptz "created_at", null: false, comment: "The timestamp of when the template was created"
    t.timestamptz "updated_at", null: false, comment: "The timestamp of when the template was last updated"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
  end

  create_table "class_schedules", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "room_id", null: false
    t.bigint "trainer_id", null: false
    t.integer "weekday"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_class_schedules_on_activity_id"
    t.index ["room_id"], name: "index_class_schedules_on_room_id"
    t.index ["trainer_id"], name: "index_class_schedules_on_trainer_id"
  end

  create_table "class_sessions", force: :cascade do |t|
    t.bigint "class_schedule_id", null: false
    t.bigint "activity_id", null: false
    t.bigint "room_id", null: false
    t.bigint "trainer_id", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "max_participants"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_class_sessions_on_activity_id"
    t.index ["class_schedule_id"], name: "index_class_sessions_on_class_schedule_id"
    t.index ["room_id"], name: "index_class_sessions_on_room_id"
    t.index ["trainer_id"], name: "index_class_sessions_on_trainer_id"
  end

  create_table "cloud_migration", id: { type: :integer, comment: "Unique ID", default: nil }, comment: "Migrate to cloud directly from Metabase", force: :cascade do |t|
    t.text "external_id", null: false, comment: "Matching ID in Cloud for this migration"
    t.text "upload_url", null: false, comment: "URL where the backup will be uploaded to"
    t.string "state", limit: 32, default: "init", null: false, comment: "Current state of the migration: init, setup, dump, upload, done, error, cancelled"
    t.integer "progress", default: 0, null: false, comment: "Number between 0 to 100 representing progress as a percentage"
    t.timestamptz "created_at", null: false, comment: "Timestamp when the config was inserted"
    t.timestamptz "updated_at", null: false, comment: "Timestamp when the config was updated"
  end

  create_table "collection", id: :integer, default: nil, force: :cascade do |t|
    t.text "name", null: false
    t.text "description"
    t.boolean "archived", default: false, null: false
    t.string "location", limit: 254, default: "/", null: false
    t.integer "personal_owner_id"
    t.string "slug", limit: 510, null: false
    t.string "namespace", limit: 254
    t.string "authority_level", limit: 255
    t.string "entity_id", limit: 21
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "Timestamp of when this Collection was created."
    t.string "type", limit: 256, comment: "This is used to differentiate instance-analytics collections from all other collections."
    t.boolean "is_sample", default: false, null: false, comment: "Is the collection part of the sample content?"
    t.string "archive_operation_id", limit: 36, comment: "The UUID of the trash operation. Each time you trash a collection subtree, you get a unique ID."
    t.boolean "archived_directly", comment: "Whether the item was trashed independently or as a subcollection"
    t.index ["location"], name: "idx_collection_location"
    t.index ["personal_owner_id"], name: "idx_collection_personal_owner_id"
    t.index ["type"], name: "idx_collection_type"
    t.unique_constraint ["entity_id"], name: "collection_entity_id_key"
    t.unique_constraint ["personal_owner_id"], name: "unique_collection_personal_owner_id"
  end

  create_table "collection_bookmark", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "collection_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.index ["collection_id"], name: "idx_collection_bookmark_collection_id"
    t.index ["user_id"], name: "idx_collection_bookmark_user_id"
    t.unique_constraint ["user_id", "collection_id"], name: "unique_collection_bookmark_user_id_collection_id"
  end

  create_table "collection_permission_graph_revision", id: :integer, default: nil, force: :cascade do |t|
    t.text "before", null: false
    t.text "after", null: false
    t.integer "user_id", null: false
    t.timestamptz "created_at", null: false
    t.text "remark"
    t.index ["user_id"], name: "idx_collection_permission_graph_revision_user_id"
  end

  create_table "connection_impersonations", id: :integer, default: nil, comment: "Table for holding connection impersonation policies", force: :cascade do |t|
    t.integer "db_id", null: false, comment: "ID of the database this connection impersonation policy affects"
    t.integer "group_id", null: false, comment: "ID of the permissions group this connection impersonation policy affects"
    t.text "attribute", comment: "User attribute associated with the database role to use for this connection impersonation policy"
    t.index ["db_id"], name: "idx_conn_impersonations_db_id"
    t.index ["group_id"], name: "idx_conn_impersonations_group_id"
    t.unique_constraint ["group_id", "db_id"], name: "conn_impersonation_unique_group_id_db_id"
  end

  create_table "core_session", id: { type: :string, limit: 254 }, force: :cascade do |t|
    t.integer "user_id", null: false
    t.timestamptz "created_at", null: false
    t.text "anti_csrf_token"
    t.string "key_hashed", limit: 254, null: false, comment: "Hashed version of the session key"
    t.index ["key_hashed"], name: "idx_core_session_key_hashed"
    t.index ["user_id"], name: "idx_core_session_user_id"
  end

  create_table "core_user", id: :integer, default: nil, force: :cascade do |t|
    t.citext "email", null: false
    t.string "first_name", limit: 254
    t.string "last_name", limit: 254
    t.string "password", limit: 254
    t.string "password_salt", limit: 254, default: "default"
    t.timestamptz "date_joined", null: false
    t.timestamptz "last_login"
    t.boolean "is_superuser", default: false, null: false
    t.boolean "is_active", default: true, null: false
    t.string "reset_token", limit: 254
    t.bigint "reset_triggered"
    t.boolean "is_qbnewb", default: true, null: false
    t.text "login_attributes"
    t.timestamptz "updated_at"
    t.string "sso_source", limit: 254
    t.string "locale", limit: 5
    t.boolean "is_datasetnewb", default: true, null: false
    t.text "settings"
    t.string "type", limit: 64, default: "personal", null: false, comment: "The type of user"
    t.string "entity_id", limit: 21, comment: "NanoID tag for each user"
    t.timestamptz "deactivated_at", comment: "The timestamp at which a user was deactivated"
    t.index "(('user_'::text || id))", name: "idx_user_qualified_id"
    t.index "((((first_name)::text || ' '::text) || (last_name)::text))", name: "idx_user_full_name"
    t.index "lower((email)::text)", name: "idx_lower_email"
    t.unique_constraint ["email"], name: "core_user_email_key"
    t.unique_constraint ["entity_id"], name: "core_user_entity_id_key"
  end

  create_table "dashboard_bookmark", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "dashboard_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.index ["dashboard_id"], name: "idx_dashboard_bookmark_dashboard_id"
    t.index ["user_id"], name: "idx_dashboard_bookmark_user_id"
    t.unique_constraint ["user_id", "dashboard_id"], name: "unique_dashboard_bookmark_user_id_dashboard_id"
  end

  create_table "dashboard_favorite", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "dashboard_id", null: false
    t.index ["dashboard_id"], name: "idx_dashboard_favorite_dashboard_id"
    t.index ["user_id"], name: "idx_dashboard_favorite_user_id"
    t.unique_constraint ["user_id", "dashboard_id"], name: "unique_dashboard_favorite_user_id_dashboard_id"
  end

  create_table "dashboard_tab", id: :integer, default: nil, comment: "Join table connecting dashboard to dashboardcards", force: :cascade do |t|
    t.integer "dashboard_id", null: false, comment: "The dashboard that a tab is on"
    t.text "name", null: false, comment: "Displayed name of the tab"
    t.integer "position", null: false, comment: "Position of the tab with respect to others tabs in dashboard"
    t.string "entity_id", limit: 21, comment: "Random NanoID tag for unique identity."
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp at which the tab was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp at which the tab was last updated"
    t.index ["dashboard_id"], name: "idx_dashboard_tab_dashboard_id"
    t.unique_constraint ["entity_id"], name: "dashboard_tab_entity_id_key"
  end

  create_table "dashboardcard_series", id: :integer, default: nil, force: :cascade do |t|
    t.integer "dashboardcard_id", null: false
    t.integer "card_id", null: false
    t.integer "position", null: false
    t.index ["card_id"], name: "idx_dashboardcard_series_card_id"
    t.index ["dashboardcard_id"], name: "idx_dashboardcard_series_dashboardcard_id"
  end

  create_table "data_permissions", id: { type: :integer, comment: "The ID of the permission", default: nil }, comment: "A table to store database and table permissions", force: :cascade do |t|
    t.integer "group_id", null: false, comment: "The ID of the associated permission group"
    t.string "perm_type", limit: 64, null: false, comment: "The type of the permission (e.g. \"data\", \"collection\", \"download\"...)"
    t.integer "db_id", null: false, comment: "A database ID, for DB and table-level permissions"
    t.string "schema_name", limit: 254, comment: "A schema name, for table-level permissions"
    t.integer "table_id", comment: "A table ID"
    t.string "perm_value", limit: 64, null: false, comment: "The value this permission is set to."
    t.index ["db_id"], name: "idx_data_permissions_db_id"
    t.index ["group_id", "db_id", "perm_value"], name: "idx_data_permissions_group_id_db_id_perm_value"
    t.index ["group_id", "db_id", "table_id", "perm_value"], name: "idx_data_permissions_group_id_db_id_table_id_perm_value"
    t.index ["group_id"], name: "idx_data_permissions_group_id"
    t.index ["table_id"], name: "idx_data_permissions_table_id"
  end

  create_table "databasechangelog", id: false, force: :cascade do |t|
    t.string "id", limit: 255, null: false
    t.string "author", limit: 255, null: false
    t.string "filename", limit: 255, null: false
    t.datetime "dateexecuted", precision: nil, null: false
    t.integer "orderexecuted", null: false
    t.string "exectype", limit: 10, null: false
    t.string "md5sum", limit: 35
    t.string "description", limit: 255
    t.string "comments", limit: 255
    t.string "tag", limit: 255
    t.string "liquibase", limit: 20
    t.string "contexts", limit: 255
    t.string "labels", limit: 255
    t.string "deployment_id", limit: 10

    t.unique_constraint ["id", "author", "filename"], name: "idx_databasechangelog_id_author_filename"
  end

  create_table "dependency", id: :integer, default: nil, force: :cascade do |t|
    t.string "model", limit: 32, null: false
    t.integer "model_id", null: false
    t.string "dependent_on_model", limit: 32, null: false
    t.integer "dependent_on_id", null: false
    t.timestamptz "created_at", null: false
    t.index ["dependent_on_id"], name: "idx_dependency_dependent_on_id"
    t.index ["dependent_on_model"], name: "idx_dependency_dependent_on_model"
    t.index ["model"], name: "idx_dependency_model"
    t.index ["model_id"], name: "idx_dependency_model_id"
  end

  create_table "dimension", id: :integer, default: nil, force: :cascade do |t|
    t.integer "field_id", null: false
    t.string "name", limit: 254, null: false
    t.string "type", limit: 254, null: false
    t.integer "human_readable_field_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "entity_id", limit: 21
    t.index ["field_id"], name: "idx_dimension_field_id"
    t.index ["human_readable_field_id"], name: "idx_dimension_human_readable_field_id"
    t.unique_constraint ["entity_id"], name: "dimension_entity_id_key"
    t.unique_constraint ["field_id"], name: "unique_dimension_field_id"
  end

  create_table "field_usage", id: { type: :integer, comment: "Unique ID", default: nil }, comment: "Used to store field usage during query execution", force: :cascade do |t|
    t.integer "field_id", null: false, comment: "ID of the field"
    t.integer "query_execution_id", null: false, comment: "referenced query execution"
    t.string "used_in", limit: 25, null: false, comment: "which part of the query the field was used in"
    t.string "filter_op", limit: 25, comment: "filter's operator that applied to the field"
    t.string "aggregation_function", limit: 25, comment: "the aggregation function that field applied to"
    t.string "breakout_temporal_unit", limit: 25, comment: "temporal unit options of the breakout"
    t.string "breakout_binning_strategy", limit: 25, comment: "the strategy of breakout"
    t.integer "breakout_binning_num_bins", comment: "The numbin option of breakout"
    t.integer "breakout_binning_bin_width", comment: "The numbin option of breakout"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The time a field usage was recorded"
    t.index ["field_id"], name: "idx_field_usage_field_id"
    t.index ["query_execution_id"], name: "idx_field_usage_query_execution_id"
  end

  create_table "gym_locations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.bigint "city_id", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["city_id"], name: "index_gym_locations_on_city_id"
  end

  create_table "http_action", primary_key: "action_id", id: { type: :integer, comment: "The related action", default: nil }, comment: "An http api call type of action", force: :cascade do |t|
    t.text "template", null: false, comment: "A template that defines method,url,body,headers required to make an api call"
    t.text "response_handle", comment: "A program to take an api response and transform to an appropriate response for emitters"
    t.text "error_handle", comment: "A program to take an api response to determine if an error occurred"
  end

  create_table "implicit_action", primary_key: "action_id", id: { type: :integer, comment: "The associated action", default: nil }, comment: "An action with dynamic parameters based on the underlying model", force: :cascade do |t|
    t.text "kind", null: false, comment: "The kind of implicit action create/update/delete"
  end

  create_table "label", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 254, null: false
    t.string "slug", limit: 254, null: false
    t.string "icon", limit: 128
    t.index ["slug"], name: "idx_label_slug"
    t.unique_constraint ["slug"], name: "label_slug_key"
  end

  create_table "login_history", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "timestamp", default: -> { "now()" }, null: false
    t.integer "user_id", null: false
    t.string "session_id", limit: 254
    t.string "device_id", limit: 36, null: false
    t.text "device_description", null: false
    t.text "ip_address", null: false
    t.index ["session_id"], name: "idx_session_id"
    t.index ["timestamp"], name: "idx_timestamp"
    t.index ["user_id", "device_id"], name: "idx_user_id_device_id"
    t.index ["user_id", "timestamp"], name: "idx_user_id_timestamp"
    t.index ["user_id"], name: "idx_user_id"
  end

  create_table "metabase_cluster_lock", primary_key: "lock_name", id: { type: :string, limit: 254, comment: "a single column that can be used to a lock across a cluster" }, comment: "A table to allow metabase instances to take locks across a cluster", force: :cascade do |t|
  end

  create_table "metabase_database", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.text "details", null: false
    t.string "engine", limit: 254, null: false
    t.boolean "is_sample", default: false, null: false
    t.boolean "is_full_sync", default: true, null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.string "metadata_sync_schedule", limit: 254, default: "0 50 * * * ? *", null: false
    t.string "cache_field_values_schedule", limit: 254
    t.string "timezone", limit: 254
    t.boolean "is_on_demand", default: false, null: false
    t.boolean "auto_run_queries", default: true, null: false
    t.boolean "refingerprint"
    t.integer "cache_ttl"
    t.string "initial_sync_status", limit: 32, default: "complete", null: false
    t.integer "creator_id"
    t.text "settings"
    t.text "dbms_version", comment: "A JSON object describing the flavor and version of the DBMS."
    t.boolean "is_audit", default: false, null: false, comment: "Only the app db, visible to admins via auditing should have this set true."
    t.boolean "uploads_enabled", default: false, null: false, comment: "Whether uploads are enabled for this database"
    t.text "uploads_schema_name", comment: "The schema name for uploads"
    t.text "uploads_table_prefix", comment: "The prefix for upload table names"
    t.boolean "is_attached_dwh", default: false, null: false, comment: "This is an attached data warehouse, do not serialize it and hide its details from the UI"
    t.string "entity_id", limit: 21, comment: "Random NanoID tag for unique identity."
    t.index ["creator_id"], name: "idx_metabase_database_creator_id"
    t.unique_constraint ["entity_id"], name: "metabase_database_entity_id_key"
  end

  create_table "metabase_field", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.string "base_type", limit: 255, null: false
    t.string "semantic_type", limit: 255
    t.boolean "active", default: true, null: false
    t.text "description"
    t.boolean "preview_display", default: true, null: false
    t.integer "position", default: 0, null: false
    t.integer "table_id", null: false
    t.integer "parent_id"
    t.string "display_name", limit: 254
    t.string "visibility_type", limit: 32, default: "normal", null: false
    t.integer "fk_target_field_id"
    t.timestamptz "last_analyzed"
    t.text "points_of_interest"
    t.text "caveats"
    t.text "fingerprint"
    t.integer "fingerprint_version", default: 0, null: false
    t.text "database_type", null: false
    t.text "has_field_values"
    t.text "settings"
    t.integer "database_position", default: 0, null: false
    t.integer "custom_position", default: 0, null: false
    t.string "effective_type", limit: 255
    t.string "coercion_strategy", limit: 255
    t.string "nfc_path", limit: 254
    t.boolean "database_required", default: false, null: false
    t.boolean "json_unfolding", default: false, null: false, comment: "Enable/disable JSON unfolding for a field"
    t.boolean "database_is_auto_increment", default: false, null: false, comment: "Indicates this field is auto incremented"
    t.boolean "database_indexed", comment: "If the database supports indexing, this column indicate whether or not a field is indexed, or is the 1st column in a composite index"
    t.boolean "database_partitioned", comment: "Whether the table is partitioned by this field"
    t.boolean "is_defective_duplicate", default: false, null: false, comment: "Indicates whether column is a defective duplicate field that should never have been created."
    t.virtual "unique_field_helper", type: :integer, as: "\nCASE\n    WHEN (is_defective_duplicate = true) THEN NULL::integer\n    ELSE\n    CASE\n        WHEN (parent_id IS NULL) THEN 0\n        ELSE parent_id\n    END\nEND", stored: true
    t.string "entity_id", limit: 21, comment: "Random NanoID tag for unique identity."
    t.index "(('field_'::text || id))", name: "idx_field_entity_qualified_id"
    t.index "lower((name)::text)", name: "idx_field_name_lower"
    t.index ["parent_id"], name: "idx_field_parent_id"
    t.index ["table_id"], name: "idx_field_table_id"
    t.unique_constraint ["entity_id"], name: "metabase_field_entity_id_key"
    t.unique_constraint ["name", "table_id", "unique_field_helper"], name: "idx_unique_field"
  end

  create_table "metabase_fieldvalues", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.text "values"
    t.text "human_readable_values"
    t.integer "field_id", null: false
    t.boolean "has_more_values", default: false
    t.string "type", limit: 32, default: "full", null: false
    t.text "hash_key"
    t.timestamptz "last_used_at", default: -> { "now()" }, null: false, comment: "Timestamp of when these FieldValues were last used."
    t.index ["field_id"], name: "idx_fieldvalues_field_id"
  end

  create_table "metabase_table", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "name", limit: 256, null: false
    t.text "description"
    t.string "entity_type", limit: 254
    t.boolean "active", null: false
    t.integer "db_id", null: false
    t.string "display_name", limit: 256
    t.string "visibility_type", limit: 254
    t.string "schema", limit: 254
    t.text "points_of_interest"
    t.text "caveats"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "field_order", limit: 254, default: "database", null: false
    t.string "initial_sync_status", limit: 32, default: "complete", null: false
    t.boolean "is_upload", default: false, null: false, comment: "Was the table created from user-uploaded (i.e., from a CSV) data?"
    t.boolean "database_require_filter", comment: "If true, the table requires a filter to be able to query it"
    t.bigint "estimated_row_count", comment: "The estimated row count"
    t.integer "view_count", default: 0, null: false, comment: "Keeps a running count of card views"
    t.string "entity_id", limit: 21, comment: "Random NanoID tag for unique identity."
    t.index ["db_id", "name"], name: "idx_uniq_table_db_id_schema_name_2col", unique: true, where: "(schema IS NULL)"
    t.index ["db_id", "schema"], name: "idx_metabase_table_db_id_schema"
    t.index ["db_id"], name: "idx_table_db_id"
    t.index ["show_in_getting_started"], name: "idx_metabase_table_show_in_getting_started"
    t.unique_constraint ["db_id", "schema", "name"], name: "idx_uniq_table_db_id_schema_name"
    t.unique_constraint ["entity_id"], name: "metabase_table_entity_id_key"
  end

  create_table "metric", id: :integer, default: nil, force: :cascade do |t|
    t.integer "table_id", null: false
    t.integer "creator_id", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.boolean "archived", default: false, null: false
    t.text "definition", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.text "how_is_this_calculated"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "entity_id", limit: 21
    t.index ["creator_id"], name: "idx_metric_creator_id"
    t.index ["show_in_getting_started"], name: "idx_metric_show_in_getting_started"
    t.index ["table_id"], name: "idx_metric_table_id"
    t.unique_constraint ["entity_id"], name: "metric_entity_id_key"
  end

  create_table "metric_important_field", id: :integer, default: nil, force: :cascade do |t|
    t.integer "metric_id", null: false
    t.integer "field_id", null: false
    t.index ["field_id"], name: "idx_metric_important_field_field_id"
    t.index ["metric_id"], name: "idx_metric_important_field_metric_id"
    t.unique_constraint ["metric_id", "field_id"], name: "unique_metric_important_field_metric_id_field_id"
  end

  create_table "model_index", id: :integer, default: nil, comment: "Used to keep track of which models have indexed columns.", force: :cascade do |t|
    t.integer "model_id", comment: "The ID of the indexed model."
    t.text "pk_ref", null: false, comment: "Serialized JSON of the primary key field ref."
    t.text "value_ref", null: false, comment: "Serialized JSON of the label field ref."
    t.text "schedule", null: false, comment: "The cron schedule for when value syncing should happen."
    t.text "state", null: false, comment: "The status of the index: initializing, indexed, error, overflow."
    t.timestamptz "indexed_at", comment: "When the status changed"
    t.text "error", comment: "The error message if the status is error."
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp of when these changes were made."
    t.integer "creator_id", null: false, comment: "ID of the user who created the event"
    t.index ["creator_id"], name: "idx_model_index_creator_id"
    t.index ["model_id"], name: "idx_model_index_model_id"
  end

  create_table "model_index_value", id: false, comment: "Used to keep track of the values indexed in a model", force: :cascade do |t|
    t.integer "model_index_id", comment: "The ID of the indexed model."
    t.bigint "model_pk", null: false, comment: "The primary key of the indexed value"
    t.text "name", null: false, comment: "The label to display identifying the indexed value."

    t.unique_constraint ["model_index_id", "model_pk"], name: "unique_model_index_value_model_index_id_model_pk"
  end

  create_table "moderation_review", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.string "status", limit: 255
    t.text "text"
    t.integer "moderated_item_id", null: false
    t.string "moderated_item_type", limit: 255, null: false
    t.integer "moderator_id", null: false
    t.boolean "most_recent", null: false
    t.index ["moderated_item_type", "moderated_item_id"], name: "idx_moderation_review_item_type_item_id"
  end

  create_table "native_query_snippet", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 254, null: false
    t.text "description"
    t.text "content", null: false
    t.integer "creator_id", null: false
    t.boolean "archived", default: false, null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.integer "collection_id"
    t.string "entity_id", limit: 21
    t.index ["collection_id"], name: "idx_snippet_collection_id"
    t.index ["creator_id"], name: "idx_native_query_snippet_creator_id"
    t.index ["name"], name: "idx_snippet_name"
    t.unique_constraint ["entity_id"], name: "native_query_snippet_entity_id_key"
    t.unique_constraint ["name"], name: "native_query_snippet_name_key"
  end

  create_table "notification", id: :integer, default: nil, comment: "join table that connect notification subscriptions and notification handlers", force: :cascade do |t|
    t.string "payload_type", limit: 64, null: false, comment: "the type of the payload"
    t.boolean "active", default: true, null: false, comment: "whether the notification is active"
    t.timestamptz "created_at", null: false, comment: "The timestamp of when the notification was created"
    t.timestamptz "updated_at", null: false, comment: "The timestamp of when the notification was updated"
    t.string "internal_id", limit: 254, comment: "the internal id of the notification"
    t.integer "payload_id", comment: "the internal id of the notification"
    t.integer "creator_id", comment: "the id of the creator"
    t.index ["creator_id"], name: "idx_notification_creator_id"
    t.unique_constraint ["internal_id"], name: "notification_internal_id_key"
  end

  create_table "notification_card", id: :integer, default: nil, comment: "Card related notifications", force: :cascade do |t|
    t.integer "card_id", comment: "the card that the alert is connected to"
    t.boolean "send_once", default: false, null: false, comment: "whether the alert should only run once"
    t.string "send_condition", limit: 32, null: false, comment: "the condition of the alert"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the recipient was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the recipient was updated"
    t.index ["card_id"], name: "idx_notification_card_card_id"
  end

  create_table "notification_handler", id: :integer, default: nil, comment: "which channel to send the notification to", force: :cascade do |t|
    t.string "channel_type", limit: 64, null: false, comment: "the type of the channel, like :channel/email, :channel/slack"
    t.integer "notification_id", null: false, comment: "the notification that the handler is connected to"
    t.integer "channel_id", comment: "the channel that the handler is connected to"
    t.integer "template_id", comment: "the template that the handler is connected to"
    t.boolean "active", default: true, null: false, comment: "whether the handler is active"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the handler was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the handler was updated"
    t.index ["channel_id"], name: "idx_notification_handler_channel_id"
    t.index ["notification_id"], name: "idx_notification_handler_notification_id"
    t.index ["template_id"], name: "idx_notification_handler_template_id"
  end

  create_table "notification_recipient", id: :integer, default: nil, comment: "who should receive the notification", force: :cascade do |t|
    t.integer "notification_handler_id", null: false, comment: "the handler that the recipient is connected to"
    t.string "type", limit: 64, null: false, comment: "the type of the recipient"
    t.integer "user_id", comment: "a user if the recipient has type user"
    t.integer "permissions_group_id", comment: "a permissions group if the recipient has type permissions_group"
    t.text "details", comment: "custom details for the recipient"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the recipient was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the recipient was updated"
    t.index ["notification_handler_id"], name: "idx_notification_recipient_notification_handler_id"
    t.index ["permissions_group_id"], name: "idx_notification_recipient_permissions_group_id"
    t.index ["user_id"], name: "idx_notification_recipient_user_id"
  end

  create_table "notification_subscription", id: :integer, default: nil, comment: "which type of trigger a notification is subscribed to", force: :cascade do |t|
    t.integer "notification_id", null: false, comment: "the notification that the subscription is connected to"
    t.string "type", limit: 64, null: false, comment: "the type of the subscription"
    t.string "event_name", limit: 64, comment: "the event name of subscriptions with type :notification-subscription/system-event"
    t.timestamptz "created_at", null: false, comment: "The timestamp of when the subscription was created"
    t.string "cron_schedule", limit: 128, comment: "the cron schedule for the subscription"
    t.string "ui_display_type", limit: 32, comment: "the display of the subscription, used for the UI only"
    t.index ["notification_id"], name: "idx_notification_subscription_notification_id"
  end

  create_table "parameter_card", id: :integer, default: nil, comment: "Join table connecting cards to entities (dashboards, other cards, etc.) that use the values generated by the card for filter values", force: :cascade do |t|
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "most recent modification time"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "creation time"
    t.integer "card_id", null: false, comment: "ID of the card generating the values"
    t.string "parameterized_object_type", limit: 32, null: false, comment: "Type of the entity consuming the values (dashboard, card, etc.)"
    t.integer "parameterized_object_id", null: false, comment: "ID of the entity consuming the values"
    t.string "parameter_id", limit: 36, null: false, comment: "The parameter ID"
    t.index ["card_id"], name: "idx_parameter_card_card_id"
    t.index ["parameterized_object_id"], name: "idx_parameter_card_parameterized_object_id"
    t.unique_constraint ["parameterized_object_id", "parameterized_object_type", "parameter_id"], name: "unique_parameterized_object_card_parameter"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "plan_id", null: false
    t.decimal "amount_paid"
    t.date "paid_on"
    t.date "expires_on"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_payments_on_plan_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "permissions", id: :integer, default: nil, force: :cascade do |t|
    t.string "object", limit: 254, null: false
    t.integer "group_id", null: false
    t.string "perm_value", limit: 64, comment: "The value of the permission"
    t.string "perm_type", limit: 64, comment: "The type of the permission"
    t.integer "collection_id", comment: "The linked collection, if applicable"
    t.index ["collection_id"], name: "idx_permissions_collection_id"
    t.index ["group_id", "object"], name: "idx_permissions_group_id_object"
    t.index ["group_id"], name: "idx_permissions_group_id"
    t.index ["object"], name: "idx_permissions_object"
    t.index ["perm_type"], name: "idx_permissions_perm_type"
    t.index ["perm_value"], name: "idx_permissions_perm_value"
    t.unique_constraint ["group_id", "object"], name: "permissions_group_id_object_key"
  end

  create_table "permissions_group", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "entity_id", limit: 21, comment: "NanoID tag for each user"
    t.index ["name"], name: "idx_permissions_group_name"
    t.unique_constraint ["entity_id"], name: "permissions_group_entity_id_key"
    t.unique_constraint ["name"], name: "unique_permissions_group_name"
  end

  create_table "permissions_group_membership", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.boolean "is_group_manager", default: false, null: false
    t.index ["group_id", "user_id"], name: "idx_permissions_group_membership_group_id_user_id"
    t.index ["group_id"], name: "idx_permissions_group_membership_group_id"
    t.index ["user_id"], name: "idx_permissions_group_membership_user_id"
    t.unique_constraint ["user_id", "group_id"], name: "unique_permissions_group_membership_user_id_group_id"
  end

  create_table "permissions_revision", id: :integer, default: nil, force: :cascade do |t|
    t.text "before", null: false
    t.text "after", null: false
    t.integer "user_id", null: false
    t.timestamptz "created_at", null: false
    t.text "remark"
    t.index ["user_id"], name: "idx_permissions_revision_user_id"
  end

  create_table "persisted_info", id: :integer, default: nil, force: :cascade do |t|
    t.integer "database_id", null: false
    t.integer "card_id"
    t.text "question_slug", null: false
    t.text "table_name", null: false
    t.text "definition"
    t.text "query_hash"
    t.boolean "active", default: false, null: false
    t.text "state", null: false
    t.timestamptz "refresh_begin", null: false
    t.timestamptz "refresh_end"
    t.timestamptz "state_change_at"
    t.text "error"
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.integer "creator_id"
    t.index ["creator_id"], name: "idx_persisted_info_creator_id"
    t.index ["database_id"], name: "idx_persisted_info_database_id"
    t.unique_constraint ["card_id"], name: "persisted_info_card_id_key"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.integer "duration"
    t.text "description"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
  end

  create_table "pulse", id: :integer, default: nil, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.string "name", limit: 254
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.boolean "skip_if_empty", default: false, null: false
    t.string "alert_condition", limit: 254
    t.boolean "alert_first_only"
    t.boolean "alert_above_goal"
    t.integer "collection_id"
    t.integer "collection_position", limit: 2
    t.boolean "archived", default: false
    t.integer "dashboard_id"
    t.text "parameters", null: false
    t.string "entity_id", limit: 21
    t.index ["collection_id"], name: "idx_pulse_collection_id"
    t.index ["creator_id"], name: "idx_pulse_creator_id"
    t.index ["dashboard_id"], name: "idx_pulse_dashboard_id"
    t.unique_constraint ["entity_id"], name: "pulse_entity_id_key"
  end

  create_table "pulse_card", id: :integer, default: nil, force: :cascade do |t|
    t.integer "pulse_id", null: false
    t.integer "card_id", null: false
    t.integer "position", null: false
    t.boolean "include_csv", default: false, null: false
    t.boolean "include_xls", default: false, null: false
    t.integer "dashboard_card_id"
    t.string "entity_id", limit: 21
    t.boolean "format_rows", default: true, comment: "Whether or not to apply formatting to the rows of the export"
    t.boolean "pivot_results", default: false, comment: "Whether or not to apply pivot processing to the rows of the export"
    t.index ["card_id"], name: "idx_pulse_card_card_id"
    t.index ["dashboard_card_id"], name: "idx_pulse_card_dashboard_card_id"
    t.index ["pulse_id"], name: "idx_pulse_card_pulse_id"
    t.unique_constraint ["entity_id"], name: "pulse_card_entity_id_key"
  end

  create_table "pulse_channel", id: :integer, default: nil, force: :cascade do |t|
    t.integer "pulse_id", null: false
    t.string "channel_type", limit: 32, null: false
    t.text "details", null: false
    t.string "schedule_type", limit: 32, null: false
    t.integer "schedule_hour"
    t.string "schedule_day", limit: 64
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "schedule_frame", limit: 32
    t.boolean "enabled", default: true, null: false
    t.string "entity_id", limit: 21
    t.integer "channel_id", comment: "The channel ID"
    t.index ["pulse_id"], name: "idx_pulse_channel_pulse_id"
    t.index ["schedule_type"], name: "idx_pulse_channel_schedule_type"
    t.unique_constraint ["entity_id"], name: "pulse_channel_entity_id_key"
  end

  create_table "pulse_channel_recipient", id: :integer, default: nil, force: :cascade do |t|
    t.integer "pulse_channel_id", null: false
    t.integer "user_id", null: false
    t.index ["pulse_channel_id"], name: "idx_pulse_channel_recipient_pulse_channel_id"
    t.index ["user_id"], name: "idx_pulse_channel_recipient_user_id"
  end

  create_table "qrtz_blob_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.binary "blob_data"
  end

  create_table "qrtz_calendars", primary_key: ["sched_name", "calendar_name"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "calendar_name", limit: 200, null: false
    t.binary "calendar", null: false
  end

  create_table "qrtz_cron_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "cron_expression", limit: 120, null: false
    t.string "time_zone_id", limit: 80
  end

  create_table "qrtz_fired_triggers", primary_key: ["sched_name", "entry_id"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "entry_id", limit: 95, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "instance_name", limit: 200, null: false
    t.bigint "fired_time", null: false
    t.bigint "sched_time"
    t.integer "priority", null: false
    t.string "state", limit: 16, null: false
    t.string "job_name", limit: 200
    t.string "job_group", limit: 200
    t.boolean "is_nonconcurrent"
    t.boolean "requests_recovery"
    t.index ["sched_name", "instance_name", "requests_recovery"], name: "idx_qrtz_ft_inst_job_req_rcvry"
    t.index ["sched_name", "instance_name"], name: "idx_qrtz_ft_trig_inst_name"
    t.index ["sched_name", "job_group"], name: "idx_qrtz_ft_jg"
    t.index ["sched_name", "job_name", "job_group"], name: "idx_qrtz_ft_j_g"
    t.index ["sched_name", "trigger_group"], name: "idx_qrtz_ft_tg"
    t.index ["sched_name", "trigger_name", "trigger_group"], name: "idx_qrtz_ft_t_g"
  end

  create_table "qrtz_job_details", primary_key: ["sched_name", "job_name", "job_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "job_name", limit: 200, null: false
    t.string "job_group", limit: 200, null: false
    t.string "description", limit: 250
    t.string "job_class_name", limit: 250, null: false
    t.boolean "is_durable", null: false
    t.boolean "is_nonconcurrent", null: false
    t.boolean "is_update_data", null: false
    t.boolean "requests_recovery", null: false
    t.binary "job_data"
    t.index ["sched_name", "job_group"], name: "idx_qrtz_j_grp"
    t.index ["sched_name", "requests_recovery"], name: "idx_qrtz_j_req_recovery"
  end

  create_table "qrtz_locks", primary_key: ["sched_name", "lock_name"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "lock_name", limit: 40, null: false
  end

  create_table "qrtz_paused_trigger_grps", primary_key: ["sched_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_group", limit: 200, null: false
  end

  create_table "qrtz_scheduler_state", primary_key: ["sched_name", "instance_name"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "instance_name", limit: 200, null: false
    t.bigint "last_checkin_time", null: false
    t.bigint "checkin_interval", null: false
  end

  create_table "qrtz_simple_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.bigint "repeat_count", null: false
    t.bigint "repeat_interval", null: false
    t.bigint "times_triggered", null: false
  end

  create_table "qrtz_simprop_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "str_prop_1", limit: 512
    t.string "str_prop_2", limit: 512
    t.string "str_prop_3", limit: 512
    t.integer "int_prop_1"
    t.integer "int_prop_2"
    t.bigint "long_prop_1"
    t.bigint "long_prop_2"
    t.decimal "dec_prop_1", precision: 13, scale: 4
    t.decimal "dec_prop_2", precision: 13, scale: 4
    t.boolean "bool_prop_1"
    t.boolean "bool_prop_2"
  end

  create_table "qrtz_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "job_name", limit: 200, null: false
    t.string "job_group", limit: 200, null: false
    t.string "description", limit: 250
    t.bigint "next_fire_time"
    t.bigint "prev_fire_time"
    t.integer "priority"
    t.string "trigger_state", limit: 16, null: false
    t.string "trigger_type", limit: 8, null: false
    t.bigint "start_time", null: false
    t.bigint "end_time"
    t.string "calendar_name", limit: 200
    t.integer "misfire_instr", limit: 2
    t.binary "job_data"
    t.index ["sched_name", "calendar_name"], name: "idx_qrtz_t_c"
    t.index ["sched_name", "job_group"], name: "idx_qrtz_t_jg"
    t.index ["sched_name", "job_name", "job_group"], name: "idx_qrtz_t_j"
    t.index ["sched_name", "misfire_instr", "next_fire_time", "trigger_group", "trigger_state"], name: "idx_qrtz_t_nft_st_misfire_grp"
    t.index ["sched_name", "misfire_instr", "next_fire_time", "trigger_state"], name: "idx_qrtz_t_nft_st_misfire"
    t.index ["sched_name", "misfire_instr", "next_fire_time"], name: "idx_qrtz_t_nft_misfire"
    t.index ["sched_name", "next_fire_time"], name: "idx_qrtz_t_next_fire_time"
    t.index ["sched_name", "trigger_group", "trigger_state"], name: "idx_qrtz_t_n_g_state"
    t.index ["sched_name", "trigger_group"], name: "idx_qrtz_t_g"
    t.index ["sched_name", "trigger_name", "trigger_group", "trigger_state"], name: "idx_qrtz_t_n_state"
    t.index ["sched_name", "trigger_state", "next_fire_time"], name: "idx_qrtz_t_nft_st"
    t.index ["sched_name", "trigger_state"], name: "idx_qrtz_t_state"
  end

  create_table "query", primary_key: "query_hash", id: :binary, force: :cascade do |t|
    t.integer "average_execution_time", null: false
    t.text "query"
  end

  create_table "query_action", primary_key: "action_id", id: { type: :integer, comment: "The related action", default: nil }, comment: "A readwrite query type of action", force: :cascade do |t|
    t.integer "database_id", null: false, comment: "The associated database"
    t.text "dataset_query", null: false, comment: "The MBQL writeback query"
    t.index ["database_id"], name: "idx_query_action_database_id"
  end

  create_table "query_analysis", id: { type: :integer, comment: "PK", default: nil }, comment: "Parent node for query analysis records", force: :cascade do |t|
    t.integer "card_id", null: false, comment: "referenced card"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the analysis was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the analysis was updated"
    t.text "status", comment: "running, failed, or completed"
    t.index ["card_id"], name: "idx_query_analysis_card_id"
  end

  create_table "query_cache", primary_key: "query_hash", id: :binary, force: :cascade do |t|
    t.timestamptz "updated_at", null: false
    t.binary "results", null: false
    t.index ["updated_at"], name: "idx_query_cache_updated_at"
  end

  create_table "query_execution", id: :integer, default: nil, force: :cascade do |t|
    t.binary "hash", null: false
    t.timestamptz "started_at", null: false
    t.integer "running_time", null: false
    t.integer "result_rows", null: false
    t.boolean "native", null: false
    t.string "context", limit: 32
    t.text "error"
    t.integer "executor_id"
    t.integer "card_id"
    t.integer "dashboard_id"
    t.integer "pulse_id"
    t.integer "database_id"
    t.boolean "cache_hit"
    t.integer "action_id", comment: "The ID of the action associated with this query execution, if any."
    t.boolean "is_sandboxed", comment: "Is query from a sandboxed user"
    t.binary "cache_hash", comment: "Hash of normalized query, calculated in middleware.cache"
    t.string "embedding_client", limit: 254, comment: "Used by the embedding team to track SDK usage"
    t.string "embedding_version", limit: 254, comment: "Used by the embedding team to track SDK version usage"
    t.boolean "parameterized", comment: "Whether or not the query has parameters with non-nil values"
    t.index "(('card_'::text || card_id))", name: "idx_query_execution_card_qualified_id"
    t.index ["action_id"], name: "idx_query_execution_action_id"
    t.index ["card_id", "started_at"], name: "idx_query_execution_card_id_started_at"
    t.index ["card_id"], name: "idx_query_execution_card_id"
    t.index ["context"], name: "idx_query_execution_context"
    t.index ["executor_id"], name: "idx_query_execution_executor_id"
    t.index ["hash", "started_at"], name: "idx_query_execution_query_hash_started_at"
    t.index ["started_at"], name: "idx_query_execution_started_at"
  end

  create_table "query_field", id: { type: :integer, comment: "PK", default: nil }, comment: "Fields used by a card's query", force: :cascade do |t|
    t.integer "card_id", null: false, comment: "referenced card"
    t.integer "field_id", comment: "referenced field"
    t.boolean "explicit_reference", default: true, null: false, comment: "Is the Field referenced directly or via a wildcard"
    t.string "column", limit: 254, null: false, comment: "name of the table or card being referenced"
    t.string "table", limit: 254, comment: "name of the table or card being referenced"
    t.integer "table_id", comment: "track the table directly, in case the field does not exist"
    t.integer "analysis_id", null: false, comment: "round of analysis"
    t.string "schema", limit: 254, comment: "name of the schema of the table being referenced"
    t.index ["analysis_id"], name: "idx_query_field_analysis_id"
    t.index ["card_id"], name: "idx_query_field_card_id"
    t.index ["field_id"], name: "idx_query_field_field_id"
  end

  create_table "query_table", id: { type: :integer, comment: "PK", default: nil }, comment: "Tables used by a card's query", force: :cascade do |t|
    t.integer "card_id", null: false, comment: "referenced card"
    t.integer "analysis_id", null: false, comment: "round of analysis"
    t.integer "table_id", comment: "referenced field"
    t.string "schema", limit: 254, comment: "name of the schema of the table being referenced"
    t.string "table", limit: 254, null: false, comment: "name of the table or card being referenced"
    t.index ["analysis_id"], name: "idx_query_table_analysis_id"
    t.index ["card_id"], name: "idx_query_table_card_id"
    t.index ["table_id"], name: "idx_query_table_table_id"
  end

  create_table "recent_views", id: :integer, default: nil, comment: "Used to store recently viewed objects for each user", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "The user associated with this view"
    t.string "model", limit: 16, null: false, comment: "The name of the model that was viewed"
    t.integer "model_id", null: false, comment: "The ID of the model that was viewed"
    t.timestamptz "timestamp", null: false, comment: "The time a view was recorded"
    t.string "context", limit: 256, default: "view", null: false, comment: "The contextual action that netted a recent view."
    t.index ["user_id"], name: "idx_recent_views_user_id"
  end

  create_table "report_card", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.string "display", limit: 254, null: false
    t.text "dataset_query", null: false
    t.text "visualization_settings", null: false
    t.integer "creator_id", null: false
    t.integer "database_id", null: false
    t.integer "table_id"
    t.string "query_type", limit: 16
    t.boolean "archived", default: false, null: false
    t.integer "collection_id"
    t.string "public_uuid", limit: 36
    t.integer "made_public_by_id"
    t.boolean "enable_embedding", default: false, null: false
    t.text "embedding_params"
    t.integer "cache_ttl"
    t.text "result_metadata"
    t.integer "collection_position", limit: 2
    t.string "entity_id", limit: 21
    t.text "parameters"
    t.text "parameter_mappings"
    t.boolean "collection_preview", default: true, null: false
    t.string "metabase_version", limit: 100, comment: "Metabase version used to create the card."
    t.string "type", limit: 16, default: "question", null: false, comment: "The type of card, could be 'question', 'model', 'metric'"
    t.timestamptz "initially_published_at", comment: "The timestamp when the card was first published in a static embed"
    t.timestamptz "cache_invalidated_at", comment: "An invalidation time that can supersede cache_config.invalidated_at"
    t.timestamptz "last_used_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "The timestamp of when the card is last used"
    t.integer "view_count", default: 0, null: false, comment: "Keeps a running count of card views"
    t.boolean "archived_directly", default: false, null: false, comment: "Was this thing trashed directly"
    t.text "dataset_query_metrics_v2_migration_backup", comment: "The copy of dataset_query before the metrics v2 migration"
    t.integer "source_card_id", comment: "The ID of the model or question this card is based on"
    t.integer "dashboard_id", comment: "The dashboard that owns the card, if it is a dashboard-internal card."
    t.index ["collection_id"], name: "idx_card_collection_id"
    t.index ["creator_id"], name: "idx_card_creator_id"
    t.index ["dashboard_id"], name: "idx_report_card_dashboard_id"
    t.index ["database_id"], name: "idx_report_card_database_id"
    t.index ["made_public_by_id"], name: "idx_report_card_made_public_by_id"
    t.index ["public_uuid"], name: "idx_card_public_uuid"
    t.index ["source_card_id"], name: "idx_report_card_source_card_id"
    t.index ["table_id"], name: "idx_report_card_table_id"
    t.unique_constraint ["entity_id"], name: "report_card_entity_id_key"
    t.unique_constraint ["public_uuid"], name: "report_card_public_uuid_key"
  end

  create_table "report_cardfavorite", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.integer "card_id", null: false
    t.integer "owner_id", null: false
    t.index ["card_id"], name: "idx_cardfavorite_card_id"
    t.index ["owner_id"], name: "idx_cardfavorite_owner_id"
    t.unique_constraint ["card_id", "owner_id"], name: "idx_unique_cardfavorite_card_id_owner_id"
  end

  create_table "report_dashboard", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.integer "creator_id", null: false
    t.text "parameters", null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "public_uuid", limit: 36
    t.integer "made_public_by_id"
    t.boolean "enable_embedding", default: false, null: false
    t.text "embedding_params"
    t.boolean "archived", default: false, null: false
    t.integer "position"
    t.integer "collection_id"
    t.integer "collection_position", limit: 2
    t.integer "cache_ttl"
    t.string "entity_id", limit: 21
    t.boolean "auto_apply_filters", default: true, null: false, comment: "Whether or not to auto-apply filters on a dashboard"
    t.string "width", limit: 16, default: "fixed", null: false, comment: "The value of the dashboard's width setting can be fixed or full. New dashboards will be set to fixed"
    t.timestamptz "initially_published_at", comment: "The timestamp when the dashboard was first published in a static embed"
    t.integer "view_count", default: 0, null: false, comment: "Keeps a running count of dashboard views"
    t.boolean "archived_directly", default: false, null: false, comment: "Was this thing trashed directly"
    t.timestamptz "last_viewed_at", default: -> { "now()" }, null: false, comment: "Timestamp of when this dashboard was last viewed"
    t.index ["collection_id"], name: "idx_dashboard_collection_id"
    t.index ["creator_id"], name: "idx_dashboard_creator_id"
    t.index ["made_public_by_id"], name: "idx_report_dashboard_made_public_by_id"
    t.index ["public_uuid"], name: "idx_dashboard_public_uuid"
    t.index ["show_in_getting_started"], name: "idx_report_dashboard_show_in_getting_started"
    t.unique_constraint ["entity_id"], name: "report_dashboard_entity_id_key"
    t.unique_constraint ["public_uuid"], name: "report_dashboard_public_uuid_key"
  end

  create_table "report_dashboardcard", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.integer "size_x", null: false
    t.integer "size_y", null: false
    t.integer "row", null: false
    t.integer "col", null: false
    t.integer "card_id"
    t.integer "dashboard_id", null: false
    t.text "parameter_mappings", null: false
    t.text "visualization_settings", null: false
    t.string "entity_id", limit: 21
    t.integer "action_id", comment: "The related action"
    t.integer "dashboard_tab_id", comment: "The referenced tab id that dashcard is on, it's nullable for dashboard with no tab"
    t.index ["action_id"], name: "idx_report_dashboardcard_action_id"
    t.index ["card_id"], name: "idx_dashboardcard_card_id"
    t.index ["dashboard_id"], name: "idx_dashboardcard_dashboard_id"
    t.index ["dashboard_tab_id"], name: "idx_report_dashboardcard_dashboard_tab_id"
    t.unique_constraint ["entity_id"], name: "report_dashboardcard_entity_id_key"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "class_session_id", null: false
    t.string "status"
    t.datetime "booked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_session_id"], name: "index_reservations_on_class_session_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "revision", id: :integer, default: nil, force: :cascade do |t|
    t.string "model", limit: 16, null: false
    t.integer "model_id", null: false
    t.integer "user_id", null: false
    t.timestamptz "timestamp", null: false
    t.text "object", null: false
    t.boolean "is_reversion", default: false, null: false
    t.boolean "is_creation", default: false, null: false
    t.text "message"
    t.boolean "most_recent", default: false, null: false, comment: "Whether a revision is the most recent one"
    t.string "metabase_version", limit: 100, comment: "Metabase version used to create the revision."
    t.index ["model", "model_id"], name: "idx_revision_model_model_id"
    t.index ["most_recent"], name: "idx_revision_most_recent"
    t.index ["user_id"], name: "idx_revision_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "capacity"
    t.bigint "gym_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gym_location_id"], name: "index_rooms_on_gym_location_id"
  end

  create_table "sandboxes", id: :integer, default: nil, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "table_id", null: false
    t.integer "card_id"
    t.text "attribute_remappings"
    t.index ["card_id"], name: "idx_sandboxes_card_id"
    t.index ["table_id", "group_id"], name: "idx_gtap_table_id_group_id"
    t.unique_constraint ["table_id", "group_id"], name: "unique_gtap_table_id_group_id"
  end

  create_table "search_index_metadata", id: :integer, default: nil, comment: "Each entry corresponds to some queryable index, and contains metadata about it.", force: :cascade do |t|
    t.string "engine", limit: 64, null: false, comment: "The kind of search engine which this index belongs to."
    t.string "version", limit: 254, null: false, comment: "Used to determine metabase compatibility. Format may depend on engine in future."
    t.string "index_name", limit: 254, null: false, comment: "The name by which the given engine refers to this particular index, e.g. table name."
    t.string "status", limit: 32, comment: "One of 'pending', 'active', or 'retired'"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the index was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the index status was updated"

    t.unique_constraint ["engine", "version", "status"], name: "idx_search_index_metadata_unique_status"
    t.unique_constraint ["index_name"], name: "search_index_metadata_index_name_key"
  end

  create_table "secret", primary_key: ["id", "version"], force: :cascade do |t|
    t.integer "id", null: false
    t.integer "version", default: 1, null: false
    t.integer "creator_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at"
    t.string "name", limit: 254, null: false
    t.string "kind", limit: 254, null: false
    t.string "source", limit: 254
    t.binary "value", null: false
    t.index ["creator_id"], name: "idx_secret_creator_id"
  end

  create_table "segment", id: :integer, default: nil, force: :cascade do |t|
    t.integer "table_id", null: false
    t.integer "creator_id", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.boolean "archived", default: false, null: false
    t.text "definition", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "entity_id", limit: 21
    t.index ["creator_id"], name: "idx_segment_creator_id"
    t.index ["show_in_getting_started"], name: "idx_segment_show_in_getting_started"
    t.index ["table_id"], name: "idx_segment_table_id"
    t.unique_constraint ["entity_id"], name: "segment_entity_id_key"
  end

  create_table "setting", primary_key: "key", id: { type: :string, limit: 254 }, force: :cascade do |t|
    t.text "value", null: false
  end

  create_table "staff_members", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "role"
    t.bigint "gym_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gym_location_id"], name: "index_staff_members_on_gym_location_id"
  end

  create_table "table_privileges", id: false, comment: "Table for user and role privileges by table", force: :cascade do |t|
    t.integer "table_id", null: false, comment: "Table ID"
    t.string "role", limit: 255, comment: "Role name. NULL indicates the privileges are the current user's"
    t.boolean "select", default: false, null: false, comment: "Privilege to select from the table"
    t.boolean "update", default: false, null: false, comment: "Privilege to update records in the table"
    t.boolean "insert", default: false, null: false, comment: "Privilege to insert records into the table"
    t.boolean "delete", default: false, null: false, comment: "Privilege to delete records from the table"
    t.index ["role"], name: "idx_table_privileges_role"
    t.index ["table_id"], name: "idx_table_privileges_table_id"
  end

  create_table "task_history", id: :integer, default: nil, force: :cascade do |t|
    t.string "task", limit: 254, null: false
    t.integer "db_id"
    t.timestamptz "started_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamptz "ended_at"
    t.integer "duration"
    t.text "task_details"
    t.string "status", limit: 21, default: "started", null: false, comment: "the status of task history, could be started, failed, success, unknown"
    t.index ["db_id"], name: "idx_task_history_db_id"
    t.index ["ended_at"], name: "idx_task_history_end_time"
    t.index ["started_at"], name: "idx_task_history_started_at"
  end

  create_table "timeline", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "description", limit: 255
    t.string "icon", limit: 128, null: false
    t.integer "collection_id"
    t.boolean "archived", default: false, null: false
    t.integer "creator_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.boolean "default", default: false, null: false
    t.string "entity_id", limit: 21
    t.index ["collection_id"], name: "idx_timeline_collection_id"
    t.index ["creator_id"], name: "idx_timeline_creator_id"
    t.unique_constraint ["entity_id"], name: "timeline_entity_id_key"
  end

  create_table "timeline_event", id: :integer, default: nil, force: :cascade do |t|
    t.integer "timeline_id", null: false
    t.string "name", limit: 255, null: false
    t.string "description", limit: 255
    t.timestamptz "timestamp", null: false
    t.boolean "time_matters", null: false
    t.string "timezone", limit: 255, null: false
    t.string "icon", limit: 128, null: false
    t.boolean "archived", default: false, null: false
    t.integer "creator_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.index ["creator_id"], name: "idx_timeline_event_creator_id"
    t.index ["timeline_id", "timestamp"], name: "idx_timeline_event_timeline_id_timestamp"
    t.index ["timeline_id"], name: "idx_timeline_event_timeline_id"
  end

  create_table "user_activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "activity_id", null: false
    t.integer "duration"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_user_activities_on_activity_id"
    t.index ["user_id"], name: "index_user_activities_on_user_id"
  end

  create_table "user_key_value", id: :integer, default: nil, comment: "A simple key value store for each user.", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "The ID of the user this KV-pair is for"
    t.string "namespace", limit: 254, null: false, comment: "The namespace for this KV, e.g. \"dashboard-filters\" or \"nobody-knows\""
    t.string "key", limit: 254, null: false, comment: "The key"
    t.text "value", comment: "The value, serialized JSON"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "When this row was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "When this row was last updated"
    t.timestamptz "expires_at", comment: "If set, when this row expires"

    t.unique_constraint ["user_id", "namespace", "key"], name: "unique_user_key_value_user_id_namespace_key"
  end

  create_table "user_parameter_value", id: :integer, default: nil, comment: "Table holding last set value of a parameter per user", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "ID of the User who has set the parameter value"
    t.string "parameter_id", limit: 36, null: false, comment: "The parameter ID"
    t.text "value", comment: "Value of the parameter"
    t.integer "dashboard_id", comment: "The ID of the dashboard"
    t.index ["dashboard_id"], name: "idx_user_parameter_value_dashboard_id"
    t.index ["user_id", "dashboard_id", "parameter_id"], name: "idx_user_parameter_value_user_id_dashboard_id_parameter_id"
    t.index ["user_id"], name: "idx_user_parameter_value_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role", default: 1, null: false
    t.bigint "gym_location_id", null: false
    t.bigint "plan_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gym_location_id"], name: "index_users_on_gym_location_id"
    t.index ["plan_id"], name: "index_users_on_plan_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "view_log", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id"
    t.string "model", limit: 16, null: false
    t.integer "model_id", null: false
    t.timestamptz "timestamp", null: false
    t.text "metadata"
    t.boolean "has_access", comment: "Whether the user who initiated the view had read access to the item being viewed."
    t.string "context", limit: 32, comment: "The context of the view, can be collection, question, or dashboard. Only for cards."
    t.string "embedding_client", limit: 254, comment: "Used by the embedding team to track SDK usage"
    t.string "embedding_version", limit: 254, comment: "Used by the embedding team to track SDK version usage"
    t.index "((((model)::text || '_'::text) || model_id))", name: "idx_view_log_entity_qualified_id"
    t.index ["model_id"], name: "idx_view_log_model_id"
    t.index ["timestamp"], name: "idx_view_log_timestamp"
    t.index ["user_id"], name: "idx_view_log_user_id"
  end

  add_foreign_key "action", "core_user", column: "creator_id", name: "fk_action_creator_id"
  add_foreign_key "action", "core_user", column: "made_public_by_id", name: "fk_action_made_public_by_id", on_delete: :cascade
  add_foreign_key "action", "report_card", column: "model_id", name: "fk_action_model_id", on_delete: :cascade
  add_foreign_key "api_key", "core_user", column: "creator_id", name: "fk_api_key_created_by_user_id"
  add_foreign_key "api_key", "core_user", column: "updated_by_id", name: "fk_api_key_updated_by_id_user_id"
  add_foreign_key "api_key", "core_user", column: "user_id", name: "fk_api_key_user_id"
  add_foreign_key "application_permissions_revision", "core_user", column: "user_id", name: "fk_general_permissions_revision_user_id"
  add_foreign_key "attendances", "class_sessions"
  add_foreign_key "attendances", "users"
  add_foreign_key "bookmark_ordering", "core_user", column: "user_id", name: "fk_bookmark_ordering_user_id", on_delete: :cascade
  add_foreign_key "card_bookmark", "core_user", column: "user_id", name: "fk_card_bookmark_user_id", on_delete: :cascade
  add_foreign_key "card_bookmark", "report_card", column: "card_id", name: "fk_card_bookmark_dashboard_id", on_delete: :cascade
  add_foreign_key "card_label", "label", name: "fk_card_label_ref_label_id", on_delete: :cascade
  add_foreign_key "card_label", "report_card", column: "card_id", name: "fk_card_label_ref_card_id", on_delete: :cascade
  add_foreign_key "class_schedules", "activities"
  add_foreign_key "class_schedules", "rooms"
  add_foreign_key "class_schedules", "staff_members", column: "trainer_id"
  add_foreign_key "class_sessions", "activities"
  add_foreign_key "class_sessions", "class_schedules"
  add_foreign_key "class_sessions", "rooms"
  add_foreign_key "class_sessions", "staff_members", column: "trainer_id"
  add_foreign_key "collection", "core_user", column: "personal_owner_id", name: "fk_collection_personal_owner_id", on_delete: :cascade
  add_foreign_key "collection_bookmark", "collection", name: "fk_collection_bookmark_collection_id", on_delete: :cascade
  add_foreign_key "collection_bookmark", "core_user", column: "user_id", name: "fk_collection_bookmark_user_id", on_delete: :cascade
  add_foreign_key "collection_permission_graph_revision", "core_user", column: "user_id", name: "fk_collection_revision_user_id", on_delete: :cascade
  add_foreign_key "connection_impersonations", "metabase_database", column: "db_id", name: "fk_conn_impersonation_db_id", on_delete: :cascade
  add_foreign_key "connection_impersonations", "permissions_group", column: "group_id", name: "fk_conn_impersonation_group_id", on_delete: :cascade
  add_foreign_key "core_session", "core_user", column: "user_id", name: "fk_session_ref_user_id", on_delete: :cascade
  add_foreign_key "dashboard_bookmark", "core_user", column: "user_id", name: "fk_dashboard_bookmark_user_id", on_delete: :cascade
  add_foreign_key "dashboard_bookmark", "report_dashboard", column: "dashboard_id", name: "fk_dashboard_bookmark_dashboard_id", on_delete: :cascade
  add_foreign_key "dashboard_favorite", "core_user", column: "user_id", name: "fk_dashboard_favorite_user_id", on_delete: :cascade
  add_foreign_key "dashboard_favorite", "report_dashboard", column: "dashboard_id", name: "fk_dashboard_favorite_dashboard_id", on_delete: :cascade
  add_foreign_key "dashboard_tab", "report_dashboard", column: "dashboard_id", name: "fk_dashboard_tab_ref_dashboard_id", on_delete: :cascade
  add_foreign_key "dashboardcard_series", "report_card", column: "card_id", name: "fk_dashboardcard_series_ref_card_id", on_delete: :cascade
  add_foreign_key "dashboardcard_series", "report_dashboardcard", column: "dashboardcard_id", name: "fk_dashboardcard_series_ref_dashboardcard_id", on_delete: :cascade
  add_foreign_key "data_permissions", "metabase_database", column: "db_id", name: "fk_data_permissions_ref_db_id", on_delete: :cascade
  add_foreign_key "data_permissions", "metabase_table", column: "table_id", name: "fk_data_permissions_ref_table_id", on_delete: :cascade
  add_foreign_key "data_permissions", "permissions_group", column: "group_id", name: "fk_data_permissions_ref_permissions_group", on_delete: :cascade
  add_foreign_key "dimension", "metabase_field", column: "field_id", name: "fk_dimension_ref_field_id", on_delete: :cascade
  add_foreign_key "dimension", "metabase_field", column: "human_readable_field_id", name: "fk_dimension_displayfk_ref_field_id", on_delete: :cascade
  add_foreign_key "field_usage", "metabase_field", column: "field_id", name: "fk_field_usage_field_id_metabase_field_id", on_delete: :cascade
  add_foreign_key "field_usage", "query_execution", name: "fk_field_usage_query_execution_id", on_delete: :cascade
  add_foreign_key "gym_locations", "cities"
  add_foreign_key "http_action", "action", name: "fk_http_action_ref_action_id", on_delete: :cascade
  add_foreign_key "implicit_action", "action", name: "fk_implicit_action_action_id", on_delete: :cascade
  add_foreign_key "login_history", "core_session", column: "session_id", name: "fk_login_history_session_id", on_delete: :nullify
  add_foreign_key "login_history", "core_user", column: "user_id", name: "fk_login_history_user_id", on_delete: :cascade
  add_foreign_key "metabase_database", "core_user", column: "creator_id", name: "fk_database_creator_id", on_delete: :nullify
  add_foreign_key "metabase_field", "metabase_field", column: "parent_id", name: "fk_field_parent_ref_field_id", on_delete: :restrict
  add_foreign_key "metabase_field", "metabase_table", column: "table_id", name: "fk_field_ref_table_id", on_delete: :cascade
  add_foreign_key "metabase_fieldvalues", "metabase_field", column: "field_id", name: "fk_fieldvalues_ref_field_id", on_delete: :cascade
  add_foreign_key "metabase_table", "metabase_database", column: "db_id", name: "fk_table_ref_database_id", on_delete: :cascade
  add_foreign_key "metric", "core_user", column: "creator_id", name: "fk_metric_ref_creator_id", on_delete: :cascade
  add_foreign_key "metric", "metabase_table", column: "table_id", name: "fk_metric_ref_table_id", on_delete: :cascade
  add_foreign_key "metric_important_field", "metabase_field", column: "field_id", name: "fk_metric_important_field_metabase_field_id", on_delete: :cascade
  add_foreign_key "metric_important_field", "metric", name: "fk_metric_important_field_metric_id", on_delete: :cascade
  add_foreign_key "model_index", "core_user", column: "creator_id", name: "fk_model_index_creator_id", on_delete: :cascade
  add_foreign_key "model_index", "report_card", column: "model_id", name: "fk_model_index_model_id", on_delete: :cascade
  add_foreign_key "model_index_value", "model_index", name: "fk_model_index_value_model_id", on_delete: :cascade
  add_foreign_key "native_query_snippet", "collection", name: "fk_snippet_collection_id", on_delete: :nullify
  add_foreign_key "native_query_snippet", "core_user", column: "creator_id", name: "fk_snippet_creator_id", on_delete: :cascade
  add_foreign_key "notification", "core_user", column: "creator_id", name: "fk_notification_creator_id", on_delete: :cascade
  add_foreign_key "notification_card", "report_card", column: "card_id", name: "fk_notification_card_card_id", on_delete: :cascade
  add_foreign_key "notification_handler", "channel", name: "fk_notification_handler_channel_id", on_delete: :cascade
  add_foreign_key "notification_handler", "channel_template", column: "template_id", name: "fk_notification_handler_template_id", on_delete: :nullify
  add_foreign_key "notification_handler", "notification", name: "fk_notification_handler_notification_id", on_delete: :cascade
  add_foreign_key "notification_recipient", "core_user", column: "user_id", name: "fk_notification_recipient_user_id", on_delete: :cascade
  add_foreign_key "notification_recipient", "notification_handler", name: "fk_notification_recipient_notification_handler_id", on_delete: :cascade
  add_foreign_key "notification_recipient", "permissions_group", name: "fk_notification_recipient_permissions_group_id", on_delete: :cascade
  add_foreign_key "notification_subscription", "notification", name: "fk_notification_subscription_notification_id", on_delete: :cascade
  add_foreign_key "parameter_card", "report_card", column: "card_id", name: "fk_parameter_card_ref_card_id", on_delete: :cascade
  add_foreign_key "payments", "plans"
  add_foreign_key "payments", "users"
  add_foreign_key "permissions", "collection", name: "fk_permissions_ref_collection_id", on_delete: :cascade
  add_foreign_key "permissions", "permissions_group", column: "group_id", name: "fk_permissions_group_id", on_delete: :cascade
  add_foreign_key "permissions_group_membership", "core_user", column: "user_id", name: "fk_permissions_group_membership_user_id", on_delete: :cascade
  add_foreign_key "permissions_group_membership", "permissions_group", column: "group_id", name: "fk_permissions_group_group_id", on_delete: :cascade
  add_foreign_key "permissions_revision", "core_user", column: "user_id", name: "fk_permissions_revision_user_id", on_delete: :cascade
  add_foreign_key "persisted_info", "core_user", column: "creator_id", name: "fk_persisted_info_ref_creator_id"
  add_foreign_key "persisted_info", "metabase_database", column: "database_id", name: "fk_persisted_info_database_id", on_delete: :cascade
  add_foreign_key "persisted_info", "report_card", column: "card_id", name: "fk_persisted_info_card_id", on_delete: :nullify
  add_foreign_key "pulse", "collection", name: "fk_pulse_collection_id", on_delete: :nullify
  add_foreign_key "pulse", "core_user", column: "creator_id", name: "fk_pulse_ref_creator_id", on_delete: :cascade
  add_foreign_key "pulse", "report_dashboard", column: "dashboard_id", name: "fk_pulse_ref_dashboard_id", on_delete: :cascade
  add_foreign_key "pulse_card", "pulse", name: "fk_pulse_card_ref_pulse_id", on_delete: :cascade
  add_foreign_key "pulse_card", "report_card", column: "card_id", name: "fk_pulse_card_ref_card_id", on_delete: :cascade
  add_foreign_key "pulse_card", "report_dashboardcard", column: "dashboard_card_id", name: "fk_pulse_card_ref_pulse_card_id", on_delete: :cascade
  add_foreign_key "pulse_channel", "channel", name: "fk_pulse_channel_channel_id", on_delete: :cascade
  add_foreign_key "pulse_channel", "pulse", name: "fk_pulse_channel_ref_pulse_id", on_delete: :cascade
  add_foreign_key "pulse_channel_recipient", "core_user", column: "user_id", name: "fk_pulse_channel_recipient_ref_user_id", on_delete: :cascade
  add_foreign_key "pulse_channel_recipient", "pulse_channel", name: "fk_pulse_channel_recipient_ref_pulse_channel_id", on_delete: :cascade
  add_foreign_key "qrtz_blob_triggers", "qrtz_triggers", column: ["sched_name", "trigger_name", "trigger_group"], primary_key: ["sched_name", "trigger_name", "trigger_group"], name: "fk_qrtz_blob_triggers_triggers"
  add_foreign_key "qrtz_cron_triggers", "qrtz_triggers", column: ["sched_name", "trigger_name", "trigger_group"], primary_key: ["sched_name", "trigger_name", "trigger_group"], name: "fk_qrtz_cron_triggers_triggers"
  add_foreign_key "qrtz_simple_triggers", "qrtz_triggers", column: ["sched_name", "trigger_name", "trigger_group"], primary_key: ["sched_name", "trigger_name", "trigger_group"], name: "fk_qrtz_simple_triggers_triggers"
  add_foreign_key "qrtz_simprop_triggers", "qrtz_triggers", column: ["sched_name", "trigger_name", "trigger_group"], primary_key: ["sched_name", "trigger_name", "trigger_group"], name: "fk_qrtz_simprop_triggers_triggers"
  add_foreign_key "qrtz_triggers", "qrtz_job_details", column: ["sched_name", "job_name", "job_group"], primary_key: ["sched_name", "job_name", "job_group"], name: "fk_qrtz_triggers_job_details"
  add_foreign_key "query_action", "action", name: "fk_query_action_ref_action_id", on_delete: :cascade
  add_foreign_key "query_action", "metabase_database", column: "database_id", name: "fk_query_action_database_id", on_delete: :cascade
  add_foreign_key "query_analysis", "report_card", column: "card_id", name: "fk_query_analysis_card_id", on_delete: :cascade
  add_foreign_key "query_field", "metabase_field", column: "field_id", name: "fk_query_field_field_id", on_delete: :cascade
  add_foreign_key "query_field", "query_analysis", column: "analysis_id", name: "fk_query_field_analysis_id", on_delete: :cascade
  add_foreign_key "query_field", "report_card", column: "card_id", name: "fk_query_field_card_id", on_delete: :cascade
  add_foreign_key "query_table", "metabase_table", column: "table_id", name: "fk_query_table_table_id", on_delete: :cascade
  add_foreign_key "query_table", "query_analysis", column: "analysis_id", name: "fk_query_table_analysis_id", on_delete: :cascade
  add_foreign_key "query_table", "report_card", column: "card_id", name: "fk_query_table_card_id", on_delete: :cascade
  add_foreign_key "recent_views", "core_user", column: "user_id", name: "fk_recent_views_ref_user_id", on_delete: :cascade
  add_foreign_key "report_card", "collection", name: "fk_card_collection_id", on_delete: :nullify
  add_foreign_key "report_card", "core_user", column: "creator_id", name: "fk_card_ref_user_id", on_delete: :cascade
  add_foreign_key "report_card", "core_user", column: "made_public_by_id", name: "fk_card_made_public_by_id", on_delete: :cascade
  add_foreign_key "report_card", "metabase_database", column: "database_id", name: "fk_report_card_ref_database_id", on_delete: :cascade
  add_foreign_key "report_card", "metabase_table", column: "table_id", name: "fk_report_card_ref_table_id", on_delete: :cascade
  add_foreign_key "report_card", "report_card", column: "source_card_id", name: "fk_report_card_source_card_id_ref_report_card_id", on_delete: :cascade
  add_foreign_key "report_card", "report_dashboard", column: "dashboard_id", name: "fk_report_card_ref_dashboard_id", on_delete: :cascade
  add_foreign_key "report_cardfavorite", "core_user", column: "owner_id", name: "fk_cardfavorite_ref_user_id", on_delete: :cascade
  add_foreign_key "report_cardfavorite", "report_card", column: "card_id", name: "fk_cardfavorite_ref_card_id", on_delete: :cascade
  add_foreign_key "report_dashboard", "collection", name: "fk_dashboard_collection_id", on_delete: :nullify
  add_foreign_key "report_dashboard", "core_user", column: "creator_id", name: "fk_dashboard_ref_user_id", on_delete: :cascade
  add_foreign_key "report_dashboard", "core_user", column: "made_public_by_id", name: "fk_dashboard_made_public_by_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "action", name: "fk_report_dashboardcard_ref_action_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "dashboard_tab", name: "fk_report_dashboardcard_ref_dashboard_tab_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "report_card", column: "card_id", name: "fk_dashboardcard_ref_card_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "report_dashboard", column: "dashboard_id", name: "fk_dashboardcard_ref_dashboard_id", on_delete: :cascade
  add_foreign_key "reservations", "class_sessions"
  add_foreign_key "reservations", "users"
  add_foreign_key "revision", "core_user", column: "user_id", name: "fk_revision_ref_user_id", on_delete: :cascade
  add_foreign_key "rooms", "gym_locations"
  add_foreign_key "sandboxes", "metabase_table", column: "table_id", name: "fk_gtap_table_id", on_delete: :cascade
  add_foreign_key "sandboxes", "permissions_group", column: "group_id", name: "fk_gtap_group_id", on_delete: :cascade
  add_foreign_key "sandboxes", "report_card", column: "card_id", name: "fk_gtap_card_id", on_delete: :cascade
  add_foreign_key "secret", "core_user", column: "creator_id", name: "fk_secret_ref_user_id"
  add_foreign_key "segment", "core_user", column: "creator_id", name: "fk_segment_ref_creator_id", on_delete: :cascade
  add_foreign_key "segment", "metabase_table", column: "table_id", name: "fk_segment_ref_table_id", on_delete: :cascade
  add_foreign_key "staff_members", "gym_locations"
  add_foreign_key "table_privileges", "metabase_table", column: "table_id", name: "fk_table_privileges_table_id", on_delete: :cascade
  add_foreign_key "timeline", "collection", name: "fk_timeline_collection_id", on_delete: :cascade
  add_foreign_key "timeline", "core_user", column: "creator_id", name: "fk_timeline_creator_id", on_delete: :cascade
  add_foreign_key "timeline_event", "core_user", column: "creator_id", name: "fk_event_creator_id", on_delete: :cascade
  add_foreign_key "timeline_event", "timeline", name: "fk_events_timeline_id", on_delete: :cascade
  add_foreign_key "user_activities", "activities"
  add_foreign_key "user_activities", "users"
  add_foreign_key "user_key_value", "core_user", column: "user_id", name: "fk_user_key_value_user_id"
  add_foreign_key "user_parameter_value", "core_user", column: "user_id", name: "fk_user_parameter_value_user_id", on_delete: :cascade
  add_foreign_key "user_parameter_value", "report_dashboard", column: "dashboard_id", name: "fk_user_parameter_value_dashboard_id", on_delete: :cascade
  add_foreign_key "users", "gym_locations"
  add_foreign_key "users", "plans"
  add_foreign_key "view_log", "core_user", column: "user_id", name: "fk_view_log_ref_user_id", on_delete: :cascade
end
