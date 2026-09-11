-- PLATE³ FINAL CONNECTOR MIGRATION
-- IMPORTANT: Your existing Supabase project already has a public `restaurants`
-- table and the `restaurant-assets` storage bucket. Do NOT run the old
-- create-table/schema script again.
-- This migration only adds the fields the PLATE³ website needs if they are missing.

alter table public.restaurants
  add column if not exists city text,
  add column if not exists phone text,
  add column if not exists email text,
  add column if not exists status text default 'processing_3d',
  add column if not exists menu_files jsonb default '[]'::jsonb,
  add column if not exists dish_photos jsonb default '[]'::jsonb,
  add column if not exists model_urls jsonb default '[]'::jsonb;

-- Keep sensible defaults for existing rows.
update public.restaurants
set status = coalesce(status, 'processing_3d'),
    menu_files = coalesce(menu_files, '[]'::jsonb),
    dish_photos = coalesce(dish_photos, '[]'::jsonb),
    model_urls = coalesce(model_urls, '[]'::jsonb)
where status is null
   or menu_files is null
   or dish_photos is null
   or model_urls is null;

-- `restaurant-assets` was already created during the earlier setup.
-- No new storage bucket is created here.
