/** @type {import('tailwindcss').Config} */
import { join } from 'path'

module.exports = {
  content: [join(__dirname, 'src/**/*.{js,ts,jsx,tsx}')],
  theme: {
    extend: {},
  },
  plugins: [],
}
