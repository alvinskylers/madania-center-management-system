# Madania Management

A web-based management system for a child therapy clinic. It covers the whole patient journey: registering families, diagnostic check-ups, therapy packages and session scheduling, session journals, therapist leave, reschedule requests, and notifications, each with its own workspace for admins, receptionists, therapists and parents.

The interface is in **Indonesian**.

> Versi bahasa Indonesia: [README.md](README.md)

## Contents

- [Features](#features)
- [Business rules](#business-rules)
- [Tech stack](#tech-stack)
- [Getting started](#getting-started)
- [Default accounts](#default-accounts)
- [Configuration](#configuration)
- [Project structure](#project-structure)
- [Important notes](#important-notes)

## Features

There are four roles. Access is enforced by URL prefix (`/admin/**`, `/receptionist/**`, `/therapist/**`, `/parent/**`).

| Role | What they can do |
|---|---|
| **Admin** | Manage users, parents, patients, therapists and receptionists; define package types; create and view therapy packages; reassign a package to another therapist; view all journals and check-ups; approve or reject leave and reschedule requests; reschedule sessions directly; see therapist utilization. |
| **Receptionist** | Register parents and patients; schedule check-ups; create therapy packages; reassign packages; review leave and reschedule requests; reschedule sessions directly from the clinic calendar. |
| **Therapist** | See their own schedule and patients; complete sessions and write therapy journals; run check-ups and record diagnosis notes; request leave; request reschedules. |
| **Parent** | See their children's schedule and progress; read session journals and comment on them; request reschedules for upcoming sessions. |

Highlights:

- **Check-ups.** A therapist diagnoses a new patient; the parent's decision (proceed to therapy or decline) is recorded; a package can then be created from the check-up.
- **Therapy packages.** A package type defines the total sessions and sessions per week (seeded: *Paket Ringan* 8/2, *Paket Reguler* 12/3, *Paket Intensif* 20/5). Creating a package generates the whole session series for the chosen days and time.
- **Therapy journals.** Each completed session gets a journal (goals, notes, progress, mood rating, recommendations) that parents can read and comment on.
- **Therapist leave.** A therapist requests leave; when an admin or receptionist approves it, the affected sessions are moved to new slots chosen by staff.
- **Package reassignment.** Move the remaining sessions of a package to another therapist, with a conflict check that shows every clash before anything is committed. History stays with the original therapist.
- **Reschedule requests.** Parents and therapists request a new time; staff approve or reject it in a queue.
- **Direct reschedule by staff.** For emergencies (a phone call about a car accident, for example), admins and receptionists click a session on the schedule calendar and move it immediately, with a required reason. See [Business rules](#business-rules).
- **Notifications.** In-app notifications for requests, approvals, rejections, reassignments and journal comments.
- **Therapist utilization.** An admin view of how busy each therapist is.
- **Calendars.** FullCalendar views with Indonesian day and month names.

## Business rules

**Scheduling (all sessions)**
- The clinic is open **08:00 – 17:00**; a session lasts one hour, so the latest start is 16:00.
- A therapist cannot be double-booked; overlapping `SCHEDULED` sessions are rejected.
- A patient cannot have overlapping active packages.

**Reschedule requests (parents and therapists)**
- Only `SCHEDULED` sessions can be rescheduled.
- The request must be made at least **3 days** before the session date (configurable, see below). After that, families are told to contact the clinic.
- The new time must be on a different date from the current session and must not be in the past.
- Only one pending request per session.

**Direct reschedule (admin and receptionist)**
- Skips the notice period and the different-date rule, so same-day moves are allowed.
- Still enforces: the session is `SCHEDULED` and not from a previous day, the new time is not in the past or identical to the current one, it is within operating hours, and it does not collide with the therapist's other sessions.
- A **reason is required** (up to 200 characters).
- The move is recorded as an approved reschedule attributed to the staff member, so it appears in the normal reschedule history. Any pending request for that session is closed as superseded.
- The parent and therapist are notified with the new time and the reason.

## Tech stack

- **Java 21**, **Spring Boot 3.5** (Web, Data JPA, Security, Validation)
- **PostgreSQL 16**
- **JTE** server-side templates (precompiled in production builds)
- **Metronic** UI, Bootstrap 5, FullCalendar 5, flatpickr
- **Lombok**, **spring-dotenv** (loads `.env`)
- **Docker / Docker Compose**, pgAdmin for database inspection

## Getting started

### Prerequisites

- JDK 21 and a PostgreSQL instance (local run), **or** Docker with Docker Compose (containerised run)

### 1. Create the `.env` file

In the project root, create a `.env` file with these keys (choose your own values):

```env
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
PGADMIN_EMAIL=
PGADMIN_PASSWORD=
```

Do not commit this file.

### 2a. Run with Docker (app + database + pgAdmin)

```bash
docker compose up --build
```

| Service | URL / port |
|---|---|
| Application | http://localhost:8080 |
| PostgreSQL | `localhost:5432` |
| pgAdmin | http://localhost:5050 |

### 2b. Run locally

Start PostgreSQL, create the database named in `POSTGRES_DB`, then:

```bash
./mvnw spring-boot:run
```

On Windows use `mvnw.cmd spring-boot:run`. The app connects to `localhost:5432` using the values in `.env`. In local development mode JTE reloads templates from `src/main/jte` without a restart.

### Build a jar

```bash
./mvnw package -DskipTests
java -jar target/management-0.0.1-SNAPSHOT.jar
```

## Default accounts

On first start the seeders create an admin, a receptionist, sample therapists, parents, patients, packages and journals so the app can be demoed immediately. Every seeded account uses the password **`password`**.

| Role | Email |
|---|---|
| Admin | `admin@madania.com` |
| Receptionist | `receptionist@madania.com` |
| Therapist | `nadia.putri@madania.com`, `rizky.hidayat@madania.com`, `amelia.wijaya@madania.com` |
| Parent | `budi.santoso@gmail.com`, `siti.rahayu@gmail.com`, `ahmad.fauzi@gmail.com`, `dewi.lestari@gmail.com` |

The admin and receptionist email and password can be overridden with the `ADMIN_EMAIL`, `ADMIN_PASSWORD`, `RECEPTIONIST_EMAIL` and `RECEPTIONIST_PASSWORD` **process environment variables**. These are read directly from the environment, so putting them only in `.env` is not enough. **Change all default passwords before using this outside a demo.**

## Configuration

Set in `src/main/resources/application.yaml`:

| Property | Default | Meaning |
|---|---|---|
| `app.timezone` | `Asia/Makassar` | Clinic timezone used by scheduling rules. Empty means the server default. |
| `app.reschedule.min-notice-days` | `3` | Minimum days of notice for parent/therapist reschedule requests. |
| `gg.jte.development-mode` | `true` | Reload templates live. Docker sets this to `false` and uses precompiled templates. |

Seeders run in order: admin, package types and receptionist, therapists, parents, patients, therapy packages, journals.

## Project structure

```
src/main/
├── java/com/madania/management/
│   ├── config/         Security, scheduling rules, model attributes, seeders
│   ├── controller/     admin/, receptionist/, therapist/, parent/ and shared controllers
│   ├── service/        Business logic (scheduling, reschedule, leave, reassignment, ...)
│   ├── entity/         JPA entities
│   ├── repository/     Spring Data repositories
│   ├── dto/            Form and request objects
│   └── enums/          Roles, statuses, therapy types, mood ratings
├── jte/
│   ├── layout/         Base layout
│   ├── components/     Reusable template parts (sidebar, navbar, modals, rows)
│   └── pages/          Templates grouped by role
└── resources/
    ├── application*.yaml
    └── static/         CSS, JS (js/custom/ holds the app's own scripts), plugins, media
```

## Important notes

- **The dev profile recreates the database on every start.** `application-dev.yaml` sets `ddl-auto: create`, which drops and rebuilds the tables (and re-runs the seeders) each time the app starts. That suits demos, but never point it at data you want to keep. Docker Compose also runs the `dev` profile. Use a separate production profile with a non-destructive setting (`validate` or `update`, or a migration tool) for real use.
- **The dev profile is noisy on purpose.** It returns full stack traces in error responses and logs SQL and debug output. Turn these off in production.
- Seeded credentials are public knowledge; see [Default accounts](#default-accounts).
- Only a smoke test exists (`ManagementApplicationTests`). The scheduling rules in `RescheduleNoticePolicy` are free of Spring and JPA and are straightforward to unit test with a fixed `Clock`.