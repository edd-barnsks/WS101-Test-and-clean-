import { createClient } from '@supabase/supabase-js';
import { DEMO_MODE } from './demo';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseKey = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY;

if (!DEMO_MODE && (!supabaseUrl || !supabaseKey)) {
  throw new Error('Missing Supabase environment variables. Set VITE_SUPABASE_URL and VITE_SUPABASE_PUBLISHABLE_KEY.');
}

// The placeholder is never contacted: all Supabase operations are bypassed in demo mode.
export const supabase = createClient(
  DEMO_MODE ? 'http://127.0.0.1:54321' : supabaseUrl!,
  DEMO_MODE ? 'local-demo-no-network' : supabaseKey!
);
