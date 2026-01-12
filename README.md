# 🚗 CANparser

Python library for parsing candump logs and CAN bus data. Useful for analyzing vehicle network traffic, replaying CAN data, and reverse engineering ECU communications.

## Features

- **Candump log parsing**: Load and parse standard candump format logs
- **ISO15765 transport layer support**: Assemble multi-frame ISO-TP sessions into complete messages
- **Request/response pairing**: Extract and match diagnostic requests with their responses
- **Dearborn Group DPA support**: Parse logs from DPA hardware (if you're into that)

## Installation
```bash
git clone https://github.com/Oggou/CANparser.git
cd CANparser
pip install -r requirements.txt
```

## Usage
```python
from candump_parser import load

# Load a candump log file
with open("vehicle_dump.log", "r") as f:
    parser = load(f)

# Access raw CAN messages
for msg in parser.messages:
    print(msg)

# Extract ISO15765 messages only
for iso_msg in parser.iso_messages:
    print(f"Src: {iso_msg.src:02x}, Dst: {iso_msg.dst:02x}")

# Parse complete ISO sessions (request + response pairs)
sessions = parser.parse_iso_sessions(src_addr=0xF9)
for session in sessions:
    req, resp = session.request_response
    print(f"Request: {req}")
    print(f"Response: {resp}")
```

## Candump Log Format

Expects standard candump format:
```
(1234567890.123456) can0 18DAF9EC#0322F190
```

## ISO15765 Support

Handles single-frame and multi-frame (transport layer) messages:
- First Frame (FF)
- Consecutive Frames (CF)
- Flow Control (FC)

Automatically reassembles segmented responses into complete data.

## File Structure

- `candump_parser.py` - Main parser class
- `network_messages.py` - CAN/ISO message classes and utilities

## Use Cases

- Vehicle diagnostics research
- ECU reverse engineering
- CAN bus traffic analysis
- Automotive security research
