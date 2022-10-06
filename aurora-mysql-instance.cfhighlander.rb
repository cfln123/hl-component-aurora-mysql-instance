CfhighlanderTemplate do
  
  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', allowedValues: ['development','production'], isGlobal: true

    ComponentParam 'DBClusterSubnetGroup'
    ComponentParam 'DBCluster'
    ComponentParam 'InstanceType', 'db.t3.medium'
    ComponentParam 'ServiceRegistry', ''
    ComponentParam 'InstanceName', 'db'

    ComponentParam 'EnablePerformanceInsights', defined?(performance_insights) ? performance_insights : false
    ComponentParam 'PerformanceInsightsRetentionPeriod', defined?(performance_insights) && defined?(insights_retention)  ? insights_retention.to_i : 7
  end

end