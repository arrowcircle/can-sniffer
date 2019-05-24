require 'csv'

class LineProcessor
  SEPARATOR = ', '.freeze

  SOURCES = {
    # masters
    '0x61A' => 'IGPD Master',
    # '0x642' => 'CCM GIS2 Master',
    # '0x602' => 'VCB Master',
    # slaves
    '0x59A' => 'IGPD Slave',
    # '0x5C2' => 'CCM GIS2 Slave',
    # '0x582' => 'VCB Slave',
    # statuses
    '0x21A' => 'IGPD Heartbeat',
    # '0x242' => 'CCM GIS2 Heartbeat',
    # '0x202' => 'VCB Heartbeat'
  }

  COMMANDS = {
    '2F 0 32 1 1 0 0 0' => 'Start HV1 Command 1',
    '60 0 32 1 0 0 0 0' => 'Response Start HV1 Command 1 OK',
    '40 0 30 1 0 0 0 0' => 'Start HV1 Command 2',
    '4F 0 30 1 16 0 0 0' => 'Response Start HV1 Command 2 OK',
    '4F 0 30 1 17 0 0 0' => 'Response Start HV1 Command 2 OK A1',
    '4F 0 30 1 1F 0 0 0' => 'Response Start HV1 Command 2 OK A2',
    '60 0 25 21 0 0 0 0' => 'Unknown command',
    '40 8 10 0 0 0 0 0' => 'Request IGPD status',
    '43 8 10 0 49 47 50 32' => 'Response Status OK',
    '40 2 64 1 0 0 0 0' => 'Request HV1 log reading',
    '40 2 64 3 0 0 0 0' => 'Request HV1 linear reading',
    '40 2 64 6 0 0 0 0' => 'Request HV2 linear reading',
    '40 2 64 4 0 0 0 0' => 'Request HV2 log reading',
    '40 2 64 2 0 0 0 0' => 'Request unknown reading 1',
    '2F 0 32 1 0 0 0 0' => 'Stop HV1',
    '1A 0 0 0' => 'Heartbeat of no changes 0',
    '1A 0 0 80' => 'Heartbeat of no changes 80',
    '1A 0 1 0' => 'Heartbeat of HV1 after C1 0',
    '1A 0 1 80' => 'Heartbeat of HV1 after C1 80',
    '1A 0 3 0' => 'Heartbeat of !unknown6! 0',
    '1A 0 3 80' => 'Heartbeat of !unknown6! 80'
    '1A 1 0 0' => 'Heartbeat HV1 Log change 0',
    '1A 1 0 80' => 'Heartbeat HV1 Log change 80',
    '1A 2 0 0' => 'Heartbeat of unknown change 0',
    '1A 2 0 80' => 'Heartbeat of unknown change 80',
    '1A 3 0 0' => 'Heartbeat of ?Log and Unknown change? 0',
    '1A 3 0 80' => 'Heartbeat of ?Log and Unknown change? 80',
    '1A 4 0 0' => 'Heartbeat of Linear change 0',
    '1A 4 0 80' => 'Heartbeat of Linear change 80',
    '1A 5 0 0' => 'Heartbeat of !unknown4! 0',
    '1A 5 0 80' => 'Heartbeat of !unknown4! 80',
    '1A 24 0 0' => 'Heartbeat of !unknown5! 0',
    '1A 24 0 80' => 'Heartbeat of !unknown5! 80'
  }

  HEADERS = {
    '4B 2 64 1' => 'Response HV1 log reading',
    '4B 2 64 2' => 'Response Unknown reading 1',
    '4B 2 64 3' => 'Response HV1 linear reading',
    '4B 2 64 4' => 'Response HV2 log reading',
    '4B 2 64 6' => 'Response HV2 linear reading'
  }

  attr_accessor :data, :comment

  def initialize(line)
    @data = line.split(SEPARATOR)
  end

  def id
    @data[1]
  end

  def ts
    @data[0]
  end

  def ts_in_sec
    ts.to_i / 1000.0
  end

  def payload
    return '' unless @data[2] && @data[2].size > 0
    @payload ||= @data[2].gsub("\r", '').gsub("\n", '').strip
  end

  def source
    res = SOURCES[id]
    res ||= 'Unknown'
    res
  end

  def command
    res = COMMANDS[payload]
    return res if res
    match_value_for_payload
  end

  def match_value_for_payload
    hex = payload.split(' ')[0..3].join(' ')
    res = HEADERS[hex]
    if res
      @comment = decrypt_payload
      return res
    end
    'unknown command'
  end

  def decrypt(pl)
    res = pl.split(' ')[4..7].map { |i| "0x#{i}" }.reverse.map { |i| i.to_i(16) }.map { |i| i.to_s(2).rjust(8, '0') }.join.to_i(2)
    pl.split(' ')[4..7]
      .map { |i| "0x#{i}" }
      .reverse
      .map { |i| i.hex }
      .map { |i| i.to_s(2).rjust(8, '0') }
      .join.to_i(2)
  end

  def decrypt_payload
    res = decrypt(payload)
    [res, res * 10.0 / 1023.0].join(SEPARATOR)
  end

  def result
    [ts_in_sec, id, payload, source, command, comment].join(SEPARATOR)
  end
end

File.foreach(ARGV[0]).with_index do |line, line_num|
  l = LineProcessor.new(line)
  puts l.result if l.source != 'Unknown'
end
