/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.svelte"],
  plugins: [require("daisyui")],
  // safelist all bg color variations with regular expresion
  theme: {
    extend: {
      keyframes: {
        "text-shimmer": {
          from: { backgroundPosition: "0 0" },
          to: { backgroundPosition: "-200% 0" },
        },
        "shimmer": {
          from: { backgroundPosition: '200% 0' },
          to: { backgroundPosition: '-200% 0' },
      },
    },
      animation: {
        "text-shimmer": "text-shimmer 2.5s ease-out infinite alternate",
          "shimmer": 'shimmer 8s ease-in-out infinite',
      },
    },
    container: {
      padding: "2rem",
    },
  },
  safelist: [
    {
      pattern: /bg-*-*/,
    },
  ],
};
