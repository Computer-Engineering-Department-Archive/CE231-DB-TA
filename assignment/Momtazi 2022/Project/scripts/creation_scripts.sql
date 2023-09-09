CREATE TABLE "accounts" (
  "username" varchar(15) PRIMARY KEY,
  "first_name" varchar(50),
  "last_name" varchar(50),
  "gender" boolean,
  "birth_date" date,
  "sickness_history" boolean,
  "password" varchar(32)
);

CREATE TABLE "nurses" (
  "username" varchar(15) PRIMARY KEY,
  "type" varchar(15),
  "code" varchar(15) UNIQUE
);

CREATE TABLE "doctors" (
  "username" varchar(15) PRIMARY KEY,
  "association_number" varchar(15) UNIQUE
);

CREATE TABLE "vaccination_centers" (
  "name" varchar(50) PRIMARY KEY,
  "address" varchar(200)
);

CREATE TABLE "vials" (
  "serial_number" int PRIMARY KEY,
  "dose_counts" int,
  "country" varchar(50),
  "created_on" date,
  "vaccination_center_name" varchar(50),
  "brand_name" varchar(50)
);

CREATE TABLE "brands" (
  "name" varchar(50) PRIMARY KEY,
  "institude" varchar(50),
  "nationality" varchar(50),
  "institude_type" varchar(15),
  "dose_count" int,
  "association_number" varchar(15),
  "period" int
);

CREATE TABLE "administrations" (
  "administrated_to" varchar(15),
  "time_stamp" date,
  "nurse_code" varchar(15),
  "vaccination_center_name" varchar(50),
  "vial_serial_number" int,
  "score" int,
  PRIMARY KEY ("administrated_to", "time_stamp", "nurse_code", "vaccination_center_name", "vial_serial_number")
);

CREATE TABLE "logs" (
  "id" SERIAL PRIMARY KEY,
  "type" varchar(15),
  "status" varchar(32),
  "username" varchar(15),
  "time_stamp" date
);

CREATE TABLE "sessions" (
  "username" varchar(15),
  "login_time" date,
  "expire_time" date,
  "token" varchar(32),
  PRIMARY KEY ("username", "token")
);

ALTER TABLE "nurses" ADD FOREIGN KEY ("username") REFERENCES "accounts" ("username") ON DELETE CASCADE;;

ALTER TABLE "doctors" ADD FOREIGN KEY ("username") REFERENCES "accounts" ("username") ON DELETE CASCADE;;

ALTER TABLE "vials" ADD FOREIGN KEY ("vaccination_center_name") REFERENCES "vaccination_centers" ("name");

ALTER TABLE "vials" ADD FOREIGN KEY ("brand_name") REFERENCES "brands" ("name");

ALTER TABLE "brands" ADD FOREIGN KEY ("association_number") REFERENCES "doctors" ("association_number") ON DELETE CASCADE;;

ALTER TABLE "administrations" ADD FOREIGN KEY ("administrated_to") REFERENCES "accounts" ("username");

ALTER TABLE "administrations" ADD FOREIGN KEY ("vaccination_center_name") REFERENCES "vaccination_centers" ("name");

ALTER TABLE "administrations" ADD FOREIGN KEY ("vial_serial_number") REFERENCES "vials" ("serial_number");

ALTER TABLE "administrations" ADD FOREIGN KEY ("nurse_code") REFERENCES "nurses" ("code");

ALTER TABLE "logs" ADD FOREIGN KEY ("username") REFERENCES "accounts" ("username") ON DELETE CASCADE;;

ALTER TABLE "sessions" ADD FOREIGN KEY ("username") REFERENCES "accounts" ("username") ON DELETE CASCADE;;

