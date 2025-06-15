# DWH Frontend

Modern web interface for the Data Warehouse Platform built with Next.js, TypeScript, and Tailwind CSS.

## Tech Stack

- **Framework**: Next.js 14 with App Router
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Animations**: Framer Motion
- **Icons**: Heroicons
- **Deployment**: Vercel (recommended)

## Features

- 🎨 Modern, responsive design inspired by Airbyte
- ⚡ Fast loading with Next.js optimizations
- 🎭 Smooth animations with Framer Motion
- 📱 Mobile-first responsive design
- 🎯 TypeScript for type safety
- 🎨 Tailwind CSS for rapid styling

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn

### Installation

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Start production server
npm start
```

## Project Structure

```
frontend/
├── src/
│   ├── app/                 # Next.js App Router
│   │   ├── layout.tsx       # Root layout
│   │   ├── page.tsx         # Home page
│   │   └── globals.css      # Global styles
│   ├── components/          # React components
│   │   ├── Navbar.tsx       # Navigation bar
│   │   ├── Hero.tsx         # Hero section
│   │   ├── Features.tsx     # Features section
│   │   ├── Architecture.tsx # Architecture section
│   │   └── Footer.tsx       # Footer
│   └── lib/                 # Utility functions
├── public/                  # Static assets
├── tailwind.config.ts       # Tailwind configuration
├── tsconfig.json           # TypeScript configuration
└── next.config.js          # Next.js configuration
```

## Components

### Navbar
- Responsive navigation with mobile menu
- Smooth scroll to sections
- CTA buttons for GitHub and Get Started

### Hero
- Animated hero section with gradient backgrounds
- Interactive architecture diagram
- Call-to-action buttons

### Features
- Grid layout showcasing platform capabilities
- Icon-based feature cards
- Hover effects and animations

### Architecture
- System component overview
- Visual data flow diagram
- Technology stack highlights

### Footer
- Links to documentation and resources
- Social media links
- Company information

## Styling

The project uses Tailwind CSS with custom color palette:

- **Primary**: Blue shades for main actions
- **Secondary**: Purple shades for accents
- **Gradients**: Used throughout for modern look

## Animations

Framer Motion is used for:
- Page load animations
- Scroll-triggered animations
- Hover effects
- Mobile menu transitions

## Development

### Adding New Components

1. Create component in `src/components/`
2. Use TypeScript for props
3. Follow existing naming conventions
4. Add to main page if needed

### Styling Guidelines

- Use Tailwind utility classes
- Follow mobile-first approach
- Use custom colors from config
- Maintain consistent spacing

## Deployment

### Vercel (Recommended)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

### Other Platforms

The project can be deployed to any platform that supports Next.js:
- Netlify
- AWS Amplify
- Railway
- DigitalOcean App Platform

## Environment Variables

No environment variables required for basic setup.

## Contributing

1. Follow TypeScript best practices
2. Use Tailwind for styling
3. Test responsive design
4. Ensure accessibility
5. Add animations thoughtfully

## License

Part of the DWH Platform project. 