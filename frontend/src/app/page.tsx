'use client'

import { motion } from 'framer-motion'
import { ArrowRightIcon, DatabaseIcon, CloudIcon, CpuChipIcon } from '@heroicons/react/24/outline'
import Navbar from '@/components/Navbar'
import Hero from '@/components/Hero'
import Features from '@/components/Features'
import Architecture from '@/components/Architecture'
import Footer from '@/components/Footer'

export default function Home() {
  return (
    <main className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50">
      <Navbar />
      <Hero />
      <Features />
      <Architecture />
      <Footer />
    </main>
  )
} 