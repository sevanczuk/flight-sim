# Flight Sim Runtime System Configuration

**Created:** 2026-04-20T07:50:00-04:00
**Source:** Steve-provided hardware/software inventory, Yellow CD session 2026-04-19
**Purpose:** Reference document describing the physical PC and peripherals where flight simulation software runs. Distinct from the development system (Ryzen 9 9950X Puget workstation) where CC/CD/Basecamp work happens.
**Load when:** Writing specs or task prompts that reference runtime hardware, diagnosing performance questions, specifying Air Manager panel targets, authoring cockpit-peripheral-dependent code, or deciding whether a software feature is runtime-system-compatible.

---

## Role

The runtime system is the **operating target** for all flight sim optimization, Air Manager instrument development, and cockpit-peripheral integration work produced in this project. It runs X-Plane 12 as primary and Microsoft Flight Simulator (2020) as secondary, with Air Manager displaying interactive cockpit panels on the touch-screen monitor.

It is **not** the system where CC/CD sessions run. Development happens on the separate Ryzen 9 9950X workstation; outputs are deployed to or tested against this runtime system.

---

## PC

**Build name:** XForcePC AMD 3D V-Cache Overkill System
**Serial:** IND-03052024-000245

| Component | Specification |
|-----------|---------------|
| Motherboard | Gigabyte X670 Aorus Elite AX ATX |
| CPU | AMD Ryzen 7 7800X3D — 8 cores / 16 threads, boost up to 5.0 GHz, 3D V-Cache |
| RAM | 64 GB DDR5-6000 (2× 32 GB G.Skill Flare X5) |
| Storage | Crucial T500 2 TB NVMe SSD |
| GPU | Zotac Trinity NVIDIA RTX 4080 |
| PSU | Seasonic Leadex VII 850W Gold |
| Case | NZXT H5 Flow Black (mid-tower) |
| Cooling | ID-Cooling DashFlow 240 AIO (top-mounted radiator); three 120mm front intake fans; one 120mm rear exhaust fan |

---

## Displays

| Role | Specification | Notes |
|------|---------------|-------|
| Primary monitor | 27-inch 4K LG | Main flight sim / game view |
| Secondary monitor | 27-inch 4K LG | Currently in use; was previously one of three |
| Cockpit panel display | 22-inch touch-screen monitor | Displays interactive cockpit panels via Air Manager |

History note: previously had three 27-inch 4K LG monitors attached; reduced to two as of the current configuration.

---

## Flight Sim Hardware Peripherals

| Device | Manufacturer / Model | Function |
|--------|---------------------|----------|
| Yoke + switch panel | Honeycomb Alpha Flight Controls | Primary flight control input |
| Throttle / prop / mixture panel | Flight Sim Stuff TPM (Throttle and Flaps Controller) | Engine controls |
| Rudder pedals | Logitech G Pro Flight Rudder Pedals | Rudder + toe brakes |
| Radio panel | Logitech G USB G Pro Flight Radio Panel | COM/NAV tuning |

---

## Software

| Title | Edition / Notes |
|-------|-----------------|
| X-Plane 12 | Primary flight simulator — project focus |
| Microsoft Flight Simulator (2020) | Premium Deluxe 40th Anniversary Edition — secondary target; long-term potential for cross-sim support |
| Air Manager | Renders interactive cockpit panels on the 22-inch touch monitor; Air Manager API is the target for custom-instrument development (near-term: Garmin GNC 355 touchscreen GPS/COM) |

---

## Relevant Development Targets

Near-term Air Manager instrument development (per project scope, claude-project-description.txt):
- **Garmin GNC 355** touchscreen GPS/COM — first custom instrument

Long-term potential:
- Cross-sim support spanning X-Plane 12 + MSFS 2020
- Additional Garmin and third-party avionics panels on the 22-inch touch display
