DROP POLICY IF EXISTS "Usuarios editan sus centros" ON public.centers;
CREATE POLICY "Usuarios editan sus centros"
  ON public.centers FOR UPDATE
  USING (auth.uid() = user_id OR auth.role() = 'authenticated')
  WITH CHECK (auth.uid() = user_id OR auth.role() = 'authenticated');
