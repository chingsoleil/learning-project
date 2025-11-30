/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#2C3E50',
        secondary: '#3498DB',
        accent: '#E74C3C',
        success: '#27AE60',
        warning: '#F39C12',
        error: '#E74C3C',
      },
      fontFamily: {
        sans: ['Noto Sans TC', 'sans-serif'],
      },
    },
  },
  plugins: [],
}

