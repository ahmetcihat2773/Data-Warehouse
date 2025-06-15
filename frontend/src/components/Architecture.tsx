'use client'

export default function Architecture() {
  return (
    <section id="architecture" className="py-20 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            System Architecture
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Built on proven technologies for enterprise-grade reliability
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div>
            <h3 className="text-2xl font-bold text-gray-900 mb-6">Components</h3>
            <div className="space-y-4">
              <div className="flex items-start space-x-4">
                <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="text-white font-bold text-sm">K</span>
                </div>
                <div>
                  <h4 className="font-semibold text-gray-900">Apache Kafka</h4>
                  <p className="text-gray-600">Distributed streaming platform for real-time data</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-4">
                <div className="w-8 h-8 bg-secondary-600 rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="text-white font-bold text-sm">D</span>
                </div>
                <div>
                  <h4 className="font-semibold text-gray-900">Debezium</h4>
                  <p className="text-gray-600">Change Data Capture for database monitoring</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-4">
                <div className="w-8 h-8 bg-green-600 rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="text-white font-bold text-sm">S</span>
                </div>
                <div>
                  <h4 className="font-semibold text-gray-900">Schema Registry</h4>
                  <p className="text-gray-600">Schema evolution and compatibility management</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-4">
                <div className="w-8 h-8 bg-purple-600 rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="text-white font-bold text-sm">P</span>
                </div>
                <div>
                  <h4 className="font-semibold text-gray-900">PostgreSQL</h4>
                  <p className="text-gray-600">Source and sink databases with full ACID compliance</p>
                </div>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-2xl shadow-xl p-8">
            <h3 className="text-xl font-bold text-gray-900 mb-6 text-center">Data Flow</h3>
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <div className="text-center">
                  <div className="w-16 h-16 bg-gradient-to-br from-blue-400 to-blue-600 rounded-xl mx-auto mb-2 flex items-center justify-center">
                    <span className="text-white font-bold">DB</span>
                  </div>
                  <p className="text-sm font-medium">Source</p>
                </div>
                <div className="flex-1 mx-4">
                  <div className="h-0.5 bg-gradient-to-r from-blue-400 to-primary-400"></div>
                </div>
                <div className="text-center">
                  <div className="w-16 h-16 bg-gradient-to-br from-primary-400 to-primary-600 rounded-xl mx-auto mb-2 flex items-center justify-center">
                    <span className="text-white font-bold">KC</span>
                  </div>
                  <p className="text-sm font-medium">Kafka Connect</p>
                </div>
              </div>
              
              <div className="text-center">
                <div className="w-2 h-8 bg-gradient-to-b from-primary-400 to-secondary-400 mx-auto"></div>
              </div>
              
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-to-br from-secondary-400 to-secondary-600 rounded-xl mx-auto mb-2 flex items-center justify-center">
                  <span className="text-white font-bold">SR</span>
                </div>
                <p className="text-sm font-medium">Schema Registry</p>
              </div>
              
              <div className="text-center">
                <div className="w-2 h-8 bg-gradient-to-b from-secondary-400 to-purple-400 mx-auto"></div>
              </div>
              
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-to-br from-purple-400 to-purple-600 rounded-xl mx-auto mb-2 flex items-center justify-center">
                  <span className="text-white font-bold">DB</span>
                </div>
                <p className="text-sm font-medium">Sink</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
} 