CloudFormation do

  Condition('EnablePerformanceInsights', FnEquals(Ref(:EnablePerformanceInsights), 'true'))
  Condition("ServiceRegistrySet", FnNot(FnEquals(Ref('ServiceRegistry'), '')))

  RDS_DBParameterGroup(:DBInstanceParameterGroup) {
    Description FnJoin(' ', [ Ref(:EnvironmentName), external_parameters[:component_name], 'instance parameter group' ])
    Family external_parameters[:family]
    Parameters external_parameters[:instance_parameters]
    Tags tags + [{ Key: 'Name', Value: FnJoin('-', [ Ref(:EnvironmentName), external_parameters[:component_name], 'instance-parameter-group' ])}]
  }

  RDS_DBInstance(:DBClusterInstance) {
    DBSubnetGroupName Ref(:DBClusterSubnetGroup)
    DBParameterGroupName Ref(:DBInstanceParameterGroup)
    DBClusterIdentifier Ref(:DBCluster)
    Engine external_parameters[:engine]
    PubliclyAccessible 'false'
    DBInstanceClass Ref(:InstanceType)
    EnablePerformanceInsights Ref('EnablePerformanceInsights')
    PerformanceInsightsRetentionPeriod FnIf('EnablePerformanceInsights', Ref('PerformanceInsightsRetentionPeriod'), Ref('AWS::NoValue'))
    Tags tags + [{ Key: 'Name', Value: FnJoin('-', [ Ref(:EnvironmentName), external_parameters[:component_name], 'instance' ])}]
  }

  Route53_RecordSet(:DBHostRecord) {
    HostedZoneName FnSub("#{external_parameters[:dns_format]}.")
    Name FnSub("${InstanceName}.#{external_parameters[:dns_format]}.")
    Type 'CNAME'
    TTL '60'
    ResourceRecords [ FnGetAtt('DBClusterInstance','Endpoint.Address') ]
  }

  ServiceDiscovery_Instance(:RegisterInstance) {
    Condition 'ServiceRegistrySet'
    InstanceAttributes(
      AWS_INSTANCE_CNAME: FnGetAtt('DBClusterInstance','Endpoint.Address')
    )
    ServiceId Ref(:ServiceRegistry)
  }
  
end