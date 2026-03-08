# CareNest - Supabase Backend Configuration

## Connection Details

- **Supabase URL:** `https://kpavgqkksmeskrvyhjuj.supabase.co`
- **Anon Key (public - for mobile app):** Found in Supabase Dashboard > Settings > API
- **Service Role Key (secret - for admin backend only):** Found in Supabase Dashboard > Settings > API

> Never commit the Service Role Key to git. Only the Anon Key is safe for client-side apps.

## Authentication

Supabase Auth handles all user login/registration. Passwords are stored in `auth.users` (managed by Supabase), NOT in our custom tables.

### Auth Flow (Mobile App)
1. **Sign Up:** `supabase.auth.signUp(email, password, data: {role: 'caregiver'|'patient'})`
2. **Sign In:** `supabase.auth.signInWithPassword(email, password)`
3. **After auth:** Check `caregiver_profiles` or `patient_profiles` for role → redirect to correct dashboard
4. **Sign Out:** `supabase.auth.signOut()`
5. **Reset Password:** `supabase.auth.resetPasswordForEmail(email)`

### Auth Flow (Admin Portal)
1. **Sign In:** `supabase.auth.signInWithPassword(email, password)`
2. **Verify:** Check `admins` table for `auth_id` match
3. **Token:** Use `access_token` from auth response as Bearer token

## Database Schema

See `../Carenest_Database/supabase_schema.sql` for the full 18-table schema.

### Core Tables
| Table | Used By |
|-------|---------|
| `admins` | Admin Portal |
| `caregiver_profiles` | Admin Portal + Mobile App |
| `patient_profiles` | Admin Portal + Mobile App |
| `caregiver_applications` | Admin Portal + Mobile App |
| `bookings` | Admin Portal + Mobile App |

### Caregiver Detail Tables
| Table | Used By |
|-------|---------|
| `caregiver_specializations` | Mobile App |
| `caregiver_certifications` | Mobile App |
| `caregiver_languages` | Mobile App |
| `caregiver_availability` | Mobile App |
| `caregiver_documents` | Admin Portal + Mobile App |

### Patient Detail Tables
| Table | Used By |
|-------|---------|
| `patient_allergies` | Mobile App |
| `patient_medical_conditions` | Mobile App |
| `patient_medications` | Mobile App |
| `patient_emergency_contacts` | Mobile App |
| `patient_insurance` | Mobile App |
| `patient_documents` | Mobile App |

### Shared Tables
| Table | Used By |
|-------|---------|
| `reviews` | Mobile App |
| `notifications` | Mobile App |

### Views
| View | Purpose |
|------|---------|
| `all_users` | Admin Portal - combines caregivers + patients |

## Test Accounts

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@carenest.lk | admin123 |
