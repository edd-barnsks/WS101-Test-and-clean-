/** Temporary VS Code preview only. Never allow demo authentication in production or on LAN/public hosts. */
export const DEMO_MODE = import.meta.env.DEV
  && import.meta.env.VITE_DEMO_MODE === 'true'
  && ['localhost', '127.0.0.1', '[::1]'].includes(window.location.hostname);
export const DEMO_USERNAME = 'demo-admin';
export const DEMO_PASSWORD = 'DemoAdmin2026!';
