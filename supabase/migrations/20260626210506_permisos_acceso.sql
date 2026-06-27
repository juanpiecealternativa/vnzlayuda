-- Dar permisos de acceso a la API para anon y authenticated
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.centers TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.volunteers TO authenticated;

-- Asegurar que nuevos objetos también tengan permisos
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO anon, authenticated;
