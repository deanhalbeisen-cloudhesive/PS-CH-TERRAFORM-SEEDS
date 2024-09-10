import boto3
import pandas as pd

# Initialize AWS clients
ec2_client = boto3.client('ec2')
pricing_client = boto3.client('pricing', region_name='us-east-1')

# Function to get storage cost per GB
def get_ebs_cost(region, volume_type):
    try:
        response = pricing_client.get_products(
            ServiceCode='AmazonEC2',
            Filters=[
                {'Type': 'TERM_MATCH', 'Field': 'volumeType', 'Value': volume_type},
                {'Type': 'TERM_MATCH', 'Field': 'location', 'Value': region},
            ],
            MaxResults=1
        )
        price_list = response['PriceList']
        if price_list:
            price_item = eval(price_list[0])['terms']['OnDemand']
            price_dimensions = next(iter(price_item.values()))['priceDimensions']
            price_per_gb_month = float(next(iter(price_dimensions.values()))['pricePerUnit']['USD'])
            return price_per_gb_month
        else:
            return 0
    except Exception as e:
        print(f"Error fetching pricing information for volume type {volume_type} in {region}: {e}")
        return 0

# Helper function to extract instance name from tags
def get_instance_name(tags):
    name = None
    if tags:
        for tag in tags:
            if tag['Key'] == 'Name':
                name = tag['Value']
                break
    return name if name else "Unnamed"

# Get EC2 instances and attached volumes
def list_ec2_instances_with_storage_cost():
    # Get all EC2 instances
    instances = ec2_client.describe_instances()
    
    # Get the region
    region = ec2_client.meta.region_name

    # List to hold the results
    results = []

    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            instance_type = instance['InstanceType']
            instance_name = get_instance_name(instance.get('Tags', []))
            total_storage_gb = 0
            monthly_cost = 0
            operating_system = "Linux"  # Assuming Linux, you can adjust based on your setup

            # Get the attached volumes
            for device in instance.get('BlockDeviceMappings', []):
                volume_id = device['Ebs']['VolumeId']
                volume_info = ec2_client.describe_volumes(VolumeIds=[volume_id])
                volume_size_gb = volume_info['Volumes'][0]['Size']
                volume_type = volume_info['Volumes'][0]['VolumeType']
                
                # Get the cost of the volume
                cost_per_gb = get_ebs_cost(region, volume_type)
                volume_cost = volume_size_gb * cost_per_gb

                # Add to totals
                total_storage_gb += volume_size_gb
                monthly_cost += volume_cost

            results.append({
                'InstanceId': instance_id,
                'InstanceName': instance_name,
                'InstanceType': instance_type,
                'Region': region,
                'OperatingSystem': operating_system,
                'Tenancy': 'Shared',  # Assuming default shared tenancy
                'InstanceCount': 1,
                'TotalStorageGB': total_storage_gb,
                'StorageType': volume_type,
                'StorageCostPerMonthUSD': monthly_cost
            })

    return results

# Save the results to an Excel file in AWS Bulk Import Format
def save_results_to_aws_calculator_format(results, file_path):
    # Define the AWS Bulk Import format columns
    columns = [
        'InstanceType', 'Region', 'InstanceCount', 'OperatingSystem', 'Tenancy', 
        'Storage', 'StorageType', 'CostPerMonth', 'InstanceName'
    ]
    
    # Flatten the data into the required format
    data = []
    for instance in results:
        data.append({
            'InstanceType': instance['InstanceType'],
            'Region': instance['Region'],
            'InstanceCount': instance['InstanceCount'],
            'OperatingSystem': instance['OperatingSystem'],
            'Tenancy': instance['Tenancy'],
            'Storage': instance['TotalStorageGB'],
            'StorageType': instance['StorageType'],
            'CostPerMonth': instance['StorageCostPerMonthUSD'],
            'InstanceName': instance['InstanceName']
        })

    # Create a DataFrame with the required columns
    df = pd.DataFrame(data, columns=columns)

    # Save to an Excel file
    df.to_excel(file_path, index=False)
    print(f"Results saved to {file_path}")

# Run the function
if __name__ == "__main__":
    # Get EC2 instances with storage cost
    results = list_ec2_instances_with_storage_cost()
    
    # File path to save the Excel file in AWS Calculator Bulk Import format
    output_path = "ec2_storage_costs_bulk_import.xlsx"
    
    # Save the results to an Excel file
    save_results_to_aws_calculator_format(results, output_path)
