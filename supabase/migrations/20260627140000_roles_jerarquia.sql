-- Agregar columna de rol
ALTER TABLE public.moderators ADD COLUMN IF NOT EXISTS role text NOT NULL DEFAULT 'moderator'
  CHECK (role IN ('owner', 'admin', 'manager', 'moderator'));

-- Asignar owner
UPDATE public.moderators SET role = 'owner' WHERE email = 'vivenesjuan332@gmail.com';

-- Función para obtener el rol del usuario actual
CREATE OR REPLACE FUNCTION public.get_my_role()
RETURNS text
LANGUAGE sql
STABLE
AS $$
  SELECT COALESCE((SELECT role FROM public.moderators WHERE email = auth.email()), '');
$$;

-- Actualizo is_moderator para que siga funcionando (cualquier rol es moderador)
CREATE OR REPLACE FUNCTION public.is_moderator()
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  SELECT EXISTS (SELECT 1 FROM public.moderators WHERE email = auth.email());
$$;

-- Políticas para moderators
DROP POLICY IF EXISTS "Moderators visibles pa todos" ON public.moderators;
CREATE POLICY "Moderators visibles pa todos"
  ON public.moderators FOR SELECT
  USING (true);

CREATE POLICY "Solo owner y admin gestionan moderadores INSERT"
  ON public.moderators FOR INSERT
  WITH CHECK (public.get_my_role() IN ('owner', 'admin'));

CREATE POLICY "Solo owner y admin gestionan moderadores UPDATE"
  ON public.moderators FOR UPDATE
  USING (public.get_my_role() IN ('owner', 'admin'));

CREATE POLICY "Solo owner y admin gestionan moderadores DELETE"
  ON public.moderators FOR DELETE
  USING (public.get_my_role() IN ('owner', 'admin'));

-- Política de DELETE en centers: owner y admin pueden eliminar cualquier centro
DROP POLICY IF EXISTS "Usuarios eliminan sus centros" ON public.centers;
CREATE POLICY "Usuarios eliminan sus centros"
  ON public.centers FOR DELETE
  USING (
    auth.uid() = user_id
    OR public.get_my_role() IN ('owner', 'admin')
  );

-- Política de UPDATE en centers: cualquier moderador puede editar
-- (ya existe: public.is_moderator())
