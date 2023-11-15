# Upgrading to v2.0

The v2.0 release contains backwards-incompatible changes.

## Miimum Provider version change
This update requires upgrading the minimum provider version to `5.5`. This is needed in order to support cross region replica. [Example for cross region replica](../examples/simple_example/) is available in [examples](../examples/) folder.

## Added network_config block
Removed obsolete parameter `network` and added `network_config` block. This will remove obsolete parmeter warning. No change in network_self_link input, Users will still provide network self link in `var.network_self_link`
