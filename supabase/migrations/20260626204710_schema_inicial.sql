-- ============================================
-- ESQUEMA SUPABASE - Venezuela Ayuda
-- Terremotos de Yaracuy 2026
-- ============================================
-- EJECUTAR EN: Supabase > SQL Editor > New Query
-- ============================================

-- 1. TABLA DE CENTROS DE ACOPIO / AYUDA
CREATE TABLE public.centers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('acopio', 'refugio', 'hospital', 'voluntariado', 'distribucion')),
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  lat DOUBLE PRECISION NOT NULL,
  lng DOUBLE PRECISION NOT NULL,
  phone TEXT,
  whatsapp TEXT,
  instagram TEXT,
  items_needed TEXT NOT NULL,
  schedule TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  verified BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABLA DE VOLUNTARIOS
CREATE TABLE public.volunteers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  phone TEXT,
  whatsapp TEXT,
  location TEXT NOT NULL,
  availability TEXT,
  skills TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================
ALTER TABLE public.centers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.volunteers ENABLE ROW LEVEL SECURITY;

-- CENTROS: todos ven aprobados, cada quien ve sus pendientes/rechazados
CREATE POLICY "Centros activos visibles pa to el mundo"
  ON public.centers FOR SELECT
  USING (status = 'approved' OR auth.uid() = user_id);

CREATE POLICY "Usuarios registran centros"
  ON public.centers FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios editan sus centros"
  ON public.centers FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Usuarios eliminan sus centros"
  ON public.centers FOR DELETE
  USING (auth.uid() = user_id);

-- VOLUNTARIOS
CREATE POLICY "Voluntarios visibles pa todos"
  ON public.volunteers FOR SELECT
  USING (true);

CREATE POLICY "Voluntarios se registran"
  ON public.volunteers FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Voluntarios editan su perfil"
  ON public.volunteers FOR UPDATE
  USING (auth.uid() = user_id);

-- ============================================
-- TRIGGER: actualizar updated_at
-- ============================================
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.centers
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ============================================
-- SEED DATA - Centros de acopio reales
-- Basado en reportes de El Nacional, NTN24,
-- El Pitazo, y El Tiempo (25-26 Jun 2026)
-- ============================================

-- NOTA: Estos son centros reportados en prensa.
-- Se insertan con un user_id por defecto. Después
-- se pueden reasignar a usuarios reales.
-- Se insertan como approved para que aparezcan
-- en el mapa desde el inicio.

INSERT INTO public.centers (user_id, name, description, type, address, city, state, lat, lng, items_needed, schedule, status, verified) VALUES

-- Distrito Capital / Caracas
(
  NULL,
  'Centro de Acopio - Club Hípico',
  'Centro de acopio habilitado por Rotaract Caracas. Reciben donaciones para los damnificados.',
  'acopio',
  'Terrazas del Club Hípico',
  'Caracas',
  'Distrito Capital',
  10.4880, -66.8550,
  'Agua potable, alimentos no perecederos, medicinas, ropa, mantas, linternas, kits de primeros auxilios',
  'Lun-Dom 8:00-20:00',
  'approved', true
),
(
  NULL,
  'Centro de Acopio - Altamira',
  'Centro de acopio del Comando ConVzla. Punto de recolección de ayuda humanitaria.',
  'acopio',
  'Cuarta avenida de Altamira, entre 9na y 10ma transversal, quinta El Bejucal',
  'Caracas',
  'Miranda',
  10.4960, -66.8480,
  'Agua, alimentos no perecederos, insumos médicos, ropa, abrigos',
  'Lun-Dom 9:00-18:00',
  'approved', true
),

-- La Guaira (zona más afectada)
(
  NULL,
  'Centro de Acopio - La Guaira',
  'Punto de recolección en el puerto. Prioridad: insumos médicos y agua embotellada.',
  'acopio',
  'Puerto de La Guaira, zona comercial',
  'La Guaira',
  'La Guaira',
  10.6056, -66.8589,
  'Medicinas, vendas, gasas, alcohol, agua embotellada, alimentos, frazadas',
  'Lun-Dom 7:00-19:00',
  'approved', true
),

-- Aragua
(
  NULL,
  'Centro de Acopio - Maracay (Comando ConVzla)',
  'Centro de acopio del Comando ConVzla en Maracay.',
  'acopio',
  'Av. 19 de Abril, Centro Comercial La Capilla, Piso 1, Local 21',
  'Maracay',
  'Aragua',
  10.2500, -67.6000,
  'Agua potable, alimentos no perecederos, ropa, medicinas, pañales',
  'Lun-Dom 9:00-18:00',
  'approved', true
),
(
  NULL,
  'Centro de Acopio - Maracay (Voluntad Popular)',
  'Centro de acopio de Voluntad Popular en Maracay.',
  'acopio',
  'Paseo de la Libertad, Av. Las Delicias, frente al Centro Médico de Maracay',
  'Maracay',
  'Aragua',
  10.2400, -67.5900,
  'Agua, alimentos, ropa, medicinas, artículos de primeros auxilios',
  'Lun-Dom 9:00-18:00',
  'approved', true
),

-- Carabobo
(
  NULL,
  'Centro de Acopio - Valencia',
  'Centro de acopio del Comando ConVzla y Operación Todos con Venezuela.',
  'acopio',
  'Av. Monseñor Adams, El Viñedo, Edificio Talislandia, Mezzanina',
  'Valencia',
  'Carabobo',
  10.1700, -68.0000,
  'Agua, alimentos no perecederos, medicinas, ropa, frazadas, kits de aseo',
  'Lun-Dom 9:00-18:00',
  'approved', true
),
(
  NULL,
  'Centro de Acopio - Bomberos Guacara',
  'Cuerpo de Bomberos habilitado como centro de acopio.',
  'acopio',
  'Carretera Nacional Guacara, sede del Cuerpo de Bomberos',
  'Guacara',
  'Carabobo',
  10.2300, -67.8700,
  'Agua, alimentos, ropa, medicinas',
  'Lun-Dom 8:00-20:00',
  'approved', true
),

-- Zulia
(
  NULL,
  'Centro de Acopio - Vente Zulia',
  'Centro de acopio habilitado por Vente Venezuela en Maracaibo.',
  'acopio',
  'Calle 70 con Av. 15A y 15B N° 15A-39 (calle paralela a Nebabrica), sede de Vente Zulia',
  'Maracaibo',
  'Zulia',
  10.6400, -71.6300,
  'Agua potable, alimentos no perecederos, medicinas, ropa, frazadas',
  'Lun-Dom 9:00-18:00',
  'approved', true
),
(
  NULL,
  'Centro de Acopio - UNT Zulia',
  'Centro de acopio habilitado por Un Nuevo Tiempo Zulia.',
  'acopio',
  'Sede regional de Un Nuevo Tiempo (UNT Zulia)',
  'Maracaibo',
  'Zulia',
  10.6450, -71.6250,
  'Agua, alimentos, medicinas, ropa, artículos de limpieza',
  'Lun-Dom 9:00-17:00',
  'approved', true
),

-- Lara
(
  NULL,
  'Centro de Acopio - Barquisimeto',
  'Centro de acopio para recibir ayuda destinada a los afectados por los sismos.',
  'acopio',
  'Tatas Food, carrera 15 entre calles 13A y 13B',
  'Barquisimeto',
  'Lara',
  10.0600, -69.3200,
  'Agua, alimentos no perecederos, ropa, medicinas, frazadas',
  'Lun-Dom 10:00-18:00',
  'approved', true
),

-- Táchira
(
  NULL,
  'Centro de Acopio - ULA Táchira',
  'Centro de acopio habilitado por la Universidad de Los Andes, núcleo Táchira.',
  'acopio',
  'Núcleo Táchira de la Universidad de Los Andes (ULA)',
  'San Cristóbal',
  'Táchira',
  7.7700, -72.2300,
  'Agua potable, alimentos no perecederos, ropa en buen estado, medicinas',
  'Lun-Vie 8:00-17:00',
  'approved', true
),

-- Monagas
(
  NULL,
  'Centro de Acopio - Maturín',
  'Centro de acopio de Voluntad Popular Monagas.',
  'acopio',
  'Calle 6, antigua Bermúdez, casa N° 11 (antiguo restaurante El Oeste)',
  'Maturín',
  'Monagas',
  9.7500, -63.1800,
  'Agua, alimentos, ropa, medicinas, artículos de primeros auxilios',
  'Lun-Dom 9:00-17:00',
  'approved', true
),

-- Bolívar
(
  NULL,
  'Centro de Acopio - Ciudad Bolívar',
  'Centro de acopio de Voluntad Popular en el estado Bolívar.',
  'acopio',
  'Esquina de Banesco, Av. República, municipio Angostura del Orinoco',
  'Ciudad Bolívar',
  'Bolívar',
  8.1200, -63.5400,
  'Agua, alimentos no perecederos, medicinas, ropa, frazadas',
  'Lun-Dom 9:00-17:00',
  'approved', true
),

-- Refugios temporales
(
  NULL,
  'Refugio Temporal - Poliedro de Caracas',
  'Refugio habilitado para damnificados. Capacidad aproximada: 500 personas. Llevar colchonetas, cobijas e higiene personal.',
  'refugio',
  'Poliedro de Caracas, Av. Libertador',
  'Caracas',
  'Distrito Capital',
  10.4460, -66.8760,
  'Colchonetas, frazadas, kits de higiene, alimentos preparados, agua',
  '24 horas',
  'approved', true
),
(
  NULL,
  'Refugio Temporal - UCV',
  'Refugio habilitado en la Universidad Central de Venezuela. Capacidad: 300 personas.',
  'refugio',
  'Universidad Central de Venezuela, Ciudad Universitaria',
  'Caracas',
  'Distrito Capital',
  10.4900, -66.8900,
  'Colchonetas, alimentos, agua, kits de aseo personal',
  '24 horas',
  'approved', true
),

-- Hospitales
(
  NULL,
  'Hospital Universitario de Caracas',
  'Principal centro de recepción de heridos. Necesitan donación de sangre urgente.',
  'hospital',
  'Av. Universidad, San Pedro',
  'Caracas',
  'Distrito Capital',
  10.5010, -66.9170,
  'Donación de sangre (todas), insumos médicos, gasas, vendas, medicamentos, guantes',
  '24 horas - Emergencias',
  'approved', true
),
(
  NULL,
  'Hospital José María Vargas',
  'Hospital de La Guaira. Atención de emergencias. Requieren insumos médicos urgentemente.',
  'hospital',
  'Av. Soublette, La Guaira',
  'La Guaira',
  'La Guaira',
  10.6036, -66.8567,
  'Insumos médicos, medicamentos, gasas, vendas, suero, guantes quirúrgicos',
  '24 horas',
  'approved', true
),
(
  NULL,
  'Hospital Pérez Carreño',
  'Recibe pacientes de Petare y zonas aledañas. Necesitan insumos y personal voluntario.',
  'hospital',
  'Av. San Martín, Oeste de Caracas',
  'Caracas',
  'Distrito Capital',
  10.4967, -66.9300,
  'Insumos médicos, medicamentos, donación de sangre',
  '24 horas',
  'approved', true
);
