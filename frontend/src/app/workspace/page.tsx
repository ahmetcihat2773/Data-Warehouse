'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import Link from 'next/link'

interface DatabaseConnection {
  id: string
  type: 'source' | 'sink'
  name: string
  host: string
  port: string
  database: string
  username: string
  password: string
  status: 'disconnected' | 'connecting' | 'connected' | 'error'
  tables?: string[]
  activeStreams?: string[]
}

interface Stream {
  id: string
  sourceTable: string
  status: 'active' | 'inactive' | 'error'
}

export default function Workspace() {
  const [sourceDB, setSourceDB] = useState<DatabaseConnection | null>(null)
  const [sinkDB, setSinkDB] = useState<DatabaseConnection | null>(null)
  const [streams, setStreams] = useState<Stream[]>([])
  const [showSourceForm, setShowSourceForm] = useState(false)
  const [showSinkForm, setShowSinkForm] = useState(false)

  const handleDrop = (e: React.DragEvent, type: 'source' | 'sink') => {
    e.preventDefault()
    if (type === 'source') {
      setShowSourceForm(true)
    } else {
      setShowSinkForm(true)
    }
  }

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault()
  }

  const testConnection = async (db: Partial<DatabaseConnection>) => {
    // Simulate connection test
    return new Promise<boolean>((resolve) => {
      setTimeout(() => {
        resolve(Math.random() > 0.3) // 70% success rate for demo
      }, 2000)
    })
  }

  const connectDatabase = async (dbData: Partial<DatabaseConnection>, type: 'source' | 'sink') => {
    const newDB: DatabaseConnection = {
      id: Date.now().toString(),
      type,
      name: dbData.name || `${type}-db`,
      host: dbData.host || '',
      port: dbData.port || '5432',
      database: dbData.database || '',
      username: dbData.username || '',
      password: dbData.password || '',
      status: 'connecting',
      tables: type === 'source' ? ['users', 'orders', 'products', 'customers'] : undefined
    }

    if (type === 'source') {
      setSourceDB(newDB)
    } else {
      setSinkDB(newDB)
    }

    // Test connection
    const isConnected = await testConnection(newDB)
    
    const updatedDB = {
      ...newDB,
      status: isConnected ? 'connected' as const : 'error' as const
    }

    if (type === 'source') {
      setSourceDB(updatedDB)
      if (isConnected) {
        // Create sample streams for each table
        const newStreams = updatedDB.tables?.map(table => ({
          id: `${table}-stream`,
          sourceTable: table,
          status: 'active' as const
        })) || []
        setStreams(newStreams)
      }
    } else {
      setSinkDB(updatedDB)
    }

    if (type === 'source') {
      setShowSourceForm(false)
    } else {
      setShowSinkForm(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <Link href="/" className="flex items-center space-x-3">
              <div className="relative">
                <div className="w-9 h-9 bg-gradient-to-br from-blue-500 to-blue-700 rounded-lg flex items-center justify-center shadow-md">
                  <svg className="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
                  </svg>
                </div>
                <div className="absolute -top-1 -right-1 w-2.5 h-2.5 bg-green-400 rounded-full border border-white"></div>
              </div>
              <div className="flex flex-col">
                <span className="text-gray-900 font-bold text-xl tracking-wide">DWH</span>
                <span className="text-gray-500 text-xs font-medium">Pipeline Builder</span>
              </div>
            </Link>
            
            <div className="flex items-center space-x-4">
              <span className="text-sm text-gray-600">Workspace</span>
              <Link href="/" className="text-sm text-blue-600 hover:text-blue-700">
                ← Back to Home
              </Link>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Data Pipeline Builder</h1>
          <p className="text-gray-600">Create and manage your real-time data streams</p>
        </div>

        {/* Pipeline Visualization */}
        <div className="bg-white rounded-xl shadow-lg p-8 min-h-[600px]">
          <div className="grid grid-cols-1 lg:grid-cols-5 gap-8 items-center h-full">
            
            {/* Source Database Zone */}
            <div className="lg:col-span-1">
              <div className="text-center mb-4">
                <h3 className="text-lg font-semibold text-gray-700 mb-2">Source Database</h3>
                <p className="text-sm text-gray-500">PostgreSQL Source</p>
              </div>
              
              {!sourceDB ? (
                <div
                  onDrop={(e) => handleDrop(e, 'source')}
                  onDragOver={handleDragOver}
                  className="border-2 border-dashed border-gray-300 rounded-xl p-8 text-center hover:border-blue-400 hover:bg-blue-50 transition-colors cursor-pointer"
                  onClick={() => setShowSourceForm(true)}
                >
                  <div className="w-16 h-16 bg-gray-100 rounded-full mx-auto mb-4 flex items-center justify-center">
                    <svg className="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                    </svg>
                  </div>
                  <p className="text-gray-500 text-sm">Click to add<br />Source Database</p>
                </div>
              ) : (
                <motion.div
                  initial={{ scale: 0.9, opacity: 0 }}
                  animate={{ scale: 1, opacity: 1 }}
                  className="bg-gradient-to-br from-green-50 to-green-100 border-2 border-green-200 rounded-xl p-6"
                >
                  <div className="flex items-center justify-between mb-4">
                    <div className="flex items-center space-x-2">
                      <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                      <span className="text-sm font-medium text-green-800">Connected</span>
                    </div>
                    <div className={`w-3 h-3 rounded-full ${
                      sourceDB.status === 'connected' ? 'bg-green-500' :
                      sourceDB.status === 'connecting' ? 'bg-yellow-500 animate-pulse' :
                      'bg-red-500'
                    }`}></div>
                  </div>
                  
                  <div className="text-center">
                    <div className="w-12 h-12 bg-green-200 rounded-lg mx-auto mb-3 flex items-center justify-center">
                      <svg className="w-6 h-6 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4" />
                      </svg>
                    </div>
                    <p className="font-medium text-gray-900 text-sm">{sourceDB.name}</p>
                    <p className="text-xs text-gray-600">{sourceDB.host}:{sourceDB.port}</p>
                  </div>

                  {/* Table Streams */}
                  {sourceDB.tables && sourceDB.status === 'connected' && (
                    <div className="mt-4 space-y-1">
                      {sourceDB.tables.map(table => (
                        <div key={table} className="flex items-center justify-between text-xs">
                          <span className="text-gray-700">{table}</span>
                          <div className="w-2 h-2 bg-green-400 rounded-full animate-pulse"></div>
                        </div>
                      ))}
                    </div>
                  )}
                </motion.div>
              )}
            </div>

            {/* Arrow 1: Source to Kafka */}
            <div className="lg:col-span-1 flex justify-center">
              {sourceDB?.status === 'connected' && (
                <motion.div
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  className="flex flex-col items-center"
                >
                  {streams.map((stream, index) => (
                    <motion.div
                      key={stream.id}
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      transition={{ delay: index * 0.1 }}
                      className="flex items-center mb-2"
                    >
                      <div className="flex items-center space-x-1">
                        <div className="w-2 h-0.5 bg-green-500"></div>
                        <div className="w-2 h-0.5 bg-green-500"></div>
                        <div className="w-2 h-0.5 bg-green-500"></div>
                        <svg className="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                        </svg>
                      </div>
                      <span className="text-xs text-gray-500 ml-2">{stream.sourceTable}</span>
                    </motion.div>
                  ))}
                </motion.div>
              )}
            </div>

            {/* Kafka Broker */}
            <div className="lg:col-span-1">
              <div className="text-center mb-4">
                <h3 className="text-lg font-semibold text-gray-700 mb-2">Kafka Broker</h3>
                <p className="text-sm text-gray-500">Message Streaming</p>
              </div>
              
              <div className="bg-gradient-to-br from-purple-50 to-purple-100 border-2 border-purple-200 rounded-xl p-6">
                <div className="text-center">
                  <div className="w-12 h-12 bg-purple-200 rounded-lg mx-auto mb-3 flex items-center justify-center">
                    <svg className="w-6 h-6 text-purple-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                    </svg>
                  </div>
                  <p className="font-medium text-gray-900 text-sm">Kafka Cluster</p>
                  <p className="text-xs text-gray-600">localhost:9092</p>
                </div>

                {streams.length > 0 && (
                  <div className="mt-4 space-y-1">
                    {streams.map(stream => (
                      <div key={stream.id} className="flex items-center justify-between text-xs">
                        <span className="text-gray-700">{stream.sourceTable}-topic</span>
                        <div className="w-2 h-2 bg-purple-400 rounded-full animate-pulse"></div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>

            {/* Arrow 2: Kafka to Sink */}
            <div className="lg:col-span-1 flex justify-center">
              {streams.length > 0 && sinkDB?.status === 'connected' && (
                <motion.div
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  className="flex flex-col items-center"
                >
                  {streams.map((stream, index) => (
                    <motion.div
                      key={stream.id}
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      transition={{ delay: index * 0.1 + 0.5 }}
                      className="flex items-center mb-2"
                    >
                      <div className="flex items-center space-x-1">
                        <div className="w-2 h-0.5 bg-blue-500"></div>
                        <div className="w-2 h-0.5 bg-blue-500"></div>
                        <div className="w-2 h-0.5 bg-blue-500"></div>
                        <svg className="w-4 h-4 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                        </svg>
                      </div>
                      <span className="text-xs text-gray-500 ml-2">{stream.sourceTable}</span>
                    </motion.div>
                  ))}
                </motion.div>
              )}
            </div>

            {/* Sink Database Zone */}
            <div className="lg:col-span-1">
              <div className="text-center mb-4">
                <h3 className="text-lg font-semibold text-gray-700 mb-2">Sink Database</h3>
                <p className="text-sm text-gray-500">PostgreSQL Sink</p>
              </div>
              
              {!sinkDB ? (
                <div
                  onDrop={(e) => handleDrop(e, 'sink')}
                  onDragOver={handleDragOver}
                  className="border-2 border-dashed border-gray-300 rounded-xl p-8 text-center hover:border-blue-400 hover:bg-blue-50 transition-colors cursor-pointer"
                  onClick={() => setShowSinkForm(true)}
                >
                  <div className="w-16 h-16 bg-gray-100 rounded-full mx-auto mb-4 flex items-center justify-center">
                    <svg className="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                    </svg>
                  </div>
                  <p className="text-gray-500 text-sm">Click to add<br />Sink Database</p>
                </div>
              ) : (
                <motion.div
                  initial={{ scale: 0.9, opacity: 0 }}
                  animate={{ scale: 1, opacity: 1 }}
                  className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-200 rounded-xl p-6"
                >
                  <div className="flex items-center justify-between mb-4">
                    <div className="flex items-center space-x-2">
                      <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
                      <span className="text-sm font-medium text-blue-800">Connected</span>
                    </div>
                    <div className={`w-3 h-3 rounded-full ${
                      sinkDB.status === 'connected' ? 'bg-blue-500' :
                      sinkDB.status === 'connecting' ? 'bg-yellow-500 animate-pulse' :
                      'bg-red-500'
                    }`}></div>
                  </div>
                  
                  <div className="text-center">
                    <div className="w-12 h-12 bg-blue-200 rounded-lg mx-auto mb-3 flex items-center justify-center">
                      <svg className="w-6 h-6 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4" />
                      </svg>
                    </div>
                    <p className="font-medium text-gray-900 text-sm">{sinkDB.name}</p>
                    <p className="text-xs text-gray-600">{sinkDB.host}:{sinkDB.port}</p>
                  </div>

                  {streams.length > 0 && sinkDB.status === 'connected' && (
                    <div className="mt-4 space-y-1">
                      {streams.map(stream => (
                        <div key={stream.id} className="flex items-center justify-between text-xs">
                          <span className="text-gray-700">{stream.sourceTable}_sink</span>
                          <div className="w-2 h-2 bg-blue-400 rounded-full animate-pulse"></div>
                        </div>
                      ))}
                    </div>
                  )}
                </motion.div>
              )}
            </div>
          </div>
        </div>
      </main>

      {/* Database Connection Forms */}
      {/* Source DB Form Modal */}
      {showSourceForm && (
        <DatabaseConnectionModal
          type="source"
          onConnect={connectDatabase}
          onClose={() => setShowSourceForm(false)}
        />
      )}

      {/* Sink DB Form Modal */}
      {showSinkForm && (
        <DatabaseConnectionModal
          type="sink"
          onConnect={connectDatabase}
          onClose={() => setShowSinkForm(false)}
        />
      )}
    </div>
  )
}

// Database Connection Modal Component
function DatabaseConnectionModal({ 
  type, 
  onConnect, 
  onClose 
}: { 
  type: 'source' | 'sink'
  onConnect: (data: any, type: 'source' | 'sink') => void
  onClose: () => void 
}) {
  const [formData, setFormData] = useState({
    name: `${type === 'source' ? 'Source' : 'Sink'} PostgreSQL`,
    host: type === 'source' ? 'localhost' : 'localhost',
    port: type === 'source' ? '5432' : '5435',
    database: type === 'source' ? 'source_db' : 'sinkdb',
    username: type === 'source' ? 'source_user' : 'sinkuser',
    password: type === 'source' ? 'source_password' : 'sinkpassword'
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onConnect(formData, type)
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <motion.div
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        className="bg-white rounded-xl shadow-2xl p-8 max-w-md w-full mx-4"
      >
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-bold text-gray-900">
            Add {type === 'source' ? 'Source' : 'Sink'} Database
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600"
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Connection Name</label>
                          <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({...formData, name: e.target.value})}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-gray-900 bg-white"
                required
              />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Host</label>
                              <input
                  type="text"
                  value={formData.host}
                  onChange={(e) => setFormData({...formData, host: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-gray-900 bg-white"
                  required
                />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Port</label>
                              <input
                  type="text"
                  value={formData.port}
                  onChange={(e) => setFormData({...formData, port: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-gray-900 bg-white"
                  required
                />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Database</label>
            <input
              type="text"
              value={formData.database}
              onChange={(e) => setFormData({...formData, database: e.target.value})}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-gray-900 bg-white"
              required
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Username</label>
            <input
              type="text"
              value={formData.username}
              onChange={(e) => setFormData({...formData, username: e.target.value})}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-gray-900 bg-white"
              required
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Password</label>
            <input
              type="password"
              value={formData.password}
              onChange={(e) => setFormData({...formData, password: e.target.value})}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-gray-900 bg-white"
              required
            />
          </div>

          <div className="flex space-x-4 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Connect & Test
            </button>
          </div>
        </form>
      </motion.div>
    </div>
  )
}