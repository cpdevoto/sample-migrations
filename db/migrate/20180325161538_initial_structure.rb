class InitialStructure < ActiveRecord::Migration[5.0]
  def self.up

    execute <<-SQL
      SET ROLE '#{ENV['DATABASE_USERNAME']}';

      -- required by `gen_random_uuid();`
      CREATE EXTENSION IF NOT EXISTS "pgcrypto" SCHEMA pg_catalog;
    SQL

    if "#{ENV['RAILS_ENV']}" != 'test'
      execute <<-SQL
        -----------
        -- ROLES --
        -----------
        DO
          $$BEGIN
            IF (SELECT 1 FROM pg_roles WHERE rolname = 'server_user') THEN
              EXECUTE 'REVOKE ALL ON SCHEMA "public" FROM server_user';
              DROP OWNED BY server_user;
            END IF;
          END$$;

        DROP USER IF EXISTS server_user;

        REVOKE ALL ON SCHEMA public FROM PUBLIC;

        CREATE USER server_user WITH PASSWORD '#{ENV['SERVER_USER_PASSWORD']}';
        GRANT USAGE ON SCHEMA public to server_user;

        ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL PRIVILEGES ON TABLES FROM PUBLIC;
        ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL PRIVILEGES ON SEQUENCES FROM PUBLIC;
        ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL PRIVILEGES ON FUNCTIONS FROM PUBLIC;
      SQL
    else
      execute <<-SQL
        GRANT SELECT ON schema_migrations TO server_user;
      SQL
    end

    execute <<-SQL
      ------------
      -- TABLES --
      ------------

      CREATE TABLE user_tbl (
        id SERIAL PRIMARY KEY,
        email CHARACTER VARYING NOT NULL UNIQUE CHECK (email <> ''),
        uuid uuid NOT NULL DEFAULT gen_random_uuid(),
        first_name CHARACTER VARYING NOT NULL DEFAULT ''::CHARACTER VARYING,
        last_name CHARACTER VARYING NOT NULL DEFAULT ''::CHARACTER VARYING,
        created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
        updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now()
      );

      ---------------
      -- FUNCTIONS --
      ---------------

      CREATE OR REPLACE FUNCTION update_updated_at_column()
        RETURNS trigger AS
        $BODY$
          BEGIN
            NEW.updated_at = now();
            RETURN NEW;
          END;
        $BODY$
        LANGUAGE plpgsql VOLATILE SECURITY DEFINER;


      --------------
      -- TRIGGERS --
      --------------

      CREATE TRIGGER update_user_updated_at_trigger
         BEFORE UPDATE ON user_tbl
         FOR EACH ROW
         EXECUTE PROCEDURE update_updated_at_column();


    SQL
  end

  def self.down
    execute <<-SQL
      DROP TRIGGER IF EXISTS update_user_updated_at_trigger ON user_tbl;

      DROP FUNCTION IF EXISTS update_updated_at_column();

      DROP TABLE IF EXISTS user_tbl;

    SQL
  end

end
