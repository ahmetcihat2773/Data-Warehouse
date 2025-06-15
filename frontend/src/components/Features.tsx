'use client'

export default function Features() {
  const features = [
    {
      title: 'Real-time Data Sync',
      description: 'Synchronize your databases in real-time with Change Data Capture (CDC)',
      icon: '⚡'
    },
    {
      title: 'Multi-tenant Support',
      description: 'Customer-specific configurations and isolated deployments',
      icon: '🏢'
    },
    {
      title: 'Schema Evolution',
      description: 'Handle schema changes automatically with Schema Registry',
      icon: '🔄'
    },
    {
      title: 'Kubernetes Native',
      description: 'Deploy with Helm charts on any Kubernetes cluster',
      icon: '☸️'
    },
    {
      title: 'Monitoring & Alerts',
      description: 'Built-in monitoring with Kafka UI and health checks',
      icon: '📊'
    },
    {
      title: 'High Availability',
      description: 'Fault-tolerant architecture with automatic failover',
      icon: '🛡️'
    }
  ]

  return (
    <section id="features" className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            Powerful Features
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Everything you need to build reliable, scalable data pipelines
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <div key={index} className="bg-gray-50 rounded-xl p-6 hover:shadow-lg transition-shadow">
              <div className="text-4xl mb-4">{feature.icon}</div>
              <h3 className="text-xl font-semibold text-gray-900 mb-2">{feature.title}</h3>
              <p className="text-gray-600">{feature.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
} 