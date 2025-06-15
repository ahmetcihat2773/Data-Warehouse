'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <nav className="bg-white/80 backdrop-blur-md border-b border-gray-200 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <h1 className="text-2xl font-bold bg-gradient-to-r from-primary-600 to-secondary-600 bg-clip-text text-transparent">
                DWH
              </h1>
            </div>
          </div>

          {/* Desktop Navigation */}
          <div className="hidden md:block">
            <div className="ml-10 flex items-baseline space-x-8">
              <a href="#features" className="text-gray-700 hover:text-primary-600 px-3 py-2 text-sm font-medium transition-colors">
                Features
              </a>
              <a href="#architecture" className="text-gray-700 hover:text-primary-600 px-3 py-2 text-sm font-medium transition-colors">
                Architecture
              </a>
              <a href="#deployment" className="text-gray-700 hover:text-primary-600 px-3 py-2 text-sm font-medium transition-colors">
                Deployment
              </a>
              <a href="#docs" className="text-gray-700 hover:text-primary-600 px-3 py-2 text-sm font-medium transition-colors">
                Documentation
              </a>
            </div>
          </div>

          {/* CTA Buttons */}
          <div className="hidden md:flex items-center space-x-4">
            <button className="text-gray-700 hover:text-primary-600 px-4 py-2 text-sm font-medium transition-colors">
              GitHub
            </button>
            <button className="bg-primary-600 hover:bg-primary-700 text-white px-6 py-2 rounded-lg text-sm font-medium transition-colors">
              Get Started
            </button>
          </div>

          {/* Mobile menu button */}
          <div className="md:hidden">
            <button
              onClick={() => setIsOpen(!isOpen)}
              className="text-gray-700 hover:text-primary-600 p-2"
            >
              <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
          </div>
        </div>
      </div>

      {/* Mobile menu */}
      {isOpen && (
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="md:hidden bg-white border-t border-gray-200"
        >
          <div className="px-2 pt-2 pb-3 space-y-1">
            <a href="#features" className="block px-3 py-2 text-gray-700 hover:text-primary-600">Features</a>
            <a href="#architecture" className="block px-3 py-2 text-gray-700 hover:text-primary-600">Architecture</a>
            <a href="#deployment" className="block px-3 py-2 text-gray-700 hover:text-primary-600">Deployment</a>
            <a href="#docs" className="block px-3 py-2 text-gray-700 hover:text-primary-600">Documentation</a>
            <div className="pt-4 pb-2 border-t border-gray-200">
              <button className="block w-full text-left px-3 py-2 text-gray-700 hover:text-primary-600">GitHub</button>
              <button className="block w-full text-left px-3 py-2 bg-primary-600 text-white rounded-lg mt-2">Get Started</button>
            </div>
          </div>
        </motion.div>
      )}
    </nav>
  )
} 