-- Moderadores pueden ver todos los centros (pending, approved, rejected)
DROP POLICY IF EXISTS "Centros activos visibles pa to el mundo" ON public.centers;
CREATE POLICY "Centros activos visibles pa to el mundo"
  ON public.centers FOR SELECT
  USING (status = 'approved' OR auth.uid() = user_id OR public.is_moderator());
