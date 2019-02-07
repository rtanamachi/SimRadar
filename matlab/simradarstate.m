function dat = simradarstate(filename)

if ~exist('filename', 'var')
    error('I need at least a filename.\n')
end

hdr = memmapfile(filename, 'Offset', 1024, 'Repeat', 1, 'Format', ...
{'int8', 1, 'verb'; ...
 'int8', 1, 'method'; ...
 'single', 24, 'params'; ...
 'uint32', 1, 'range_count'; ...
 'uint32', 1, 'random_seed'; ...
 'int8', 1, 'status'; ...
 'uint64', 1, 'sim_tic'; ...
 'uint64', 1, 'sim_toc'; ...
 'single', 1, 'sim_time'; ...
 'single', 16, 'sim_desc'; ...
 'uint32', 1, 'sim_concept'; ...
 'uint32', 6, 'vel_adm_rcs_idx_count'; ...
 'uint8', 120, 'vel_desc_struct'; ...
 'uint8', 2160 * 8, 'adm_desc_struct'; ...
 'uint8', 2136 * 8, 'rcs_desc_struct'; ...
 'uint64', 1, 'num_scats'; ...
 'uint64', 1, 'num_body_types'; ...
 'uint64', 8, 'debris_population'});

params = hdr.data.params;

dat.hdr = hdr.data;
dat.params = struct(...
    'c', params(1), ...
    'prt', params(2), ...
    'loss', params(3), ...
    'lambda', params(4), ...
    'tx_power_watt', params(5), ...
    'antenna_gain_dbi', params(6), ...
    'antenna_bw_deg', params(7), ...
    'tau', params(8), ...
    'range_start', params(9), ...
    'range_end', params(10), ...
    'range_delta', params(11), ...
    'azimuth_start_deg' , params(12), ...
    'azimuth_end_deg' , params(13), ...
    'azimuth_delta_deg' , params(14), ...
    'elevation_start_deg' , params(15), ...
    'elevation_end_deg' , params(16), ...
    'elevation_delta_deg' , params(17), ...
    'domain_pad_factor', params(18), ...
    'body_per_cell', params(19), ...
    'prf', params(20), ...
    'va', params(21), ...
    'fn', params(22), ...
    'antenna_bw_rad', params(23), ...
    'dr', params(24), ...
    'range_count', hdr.data.range_count);

fid = fopen(filename, 'r');
fseek(fid, 64 * 1024, 'bof');
dat.pos = fread(fid, [4, dat.hdr.num_scats], 'float');

fclose(fid);

