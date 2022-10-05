CfhighlanderTemplate do
  
  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', allowedValues: ['development','production'], isGlobal: true

    ComponentParam 'DBClusterSubnetGroup'
    ComponentParam 'DBInstanceParameterGroup'
    ComponentParam 'DBCluster'
    ComponentParam 'InstanceType'
    ComponentParam 'ServiceRegistry'

    ComponentParam 'EnablePerformanceInsights', defined?(performance_insights) ? performance_insights : false
    ComponentParam 'PerformanceInsightsRetentionPeriod', defined?(performance_insights) && defined?(insights_retention)  ? insights_retention.to_i : 7
  end

end