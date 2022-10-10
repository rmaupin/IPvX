# IPvX
IPvX IP calculator

Originally a demonstration of the IP.pas IP library I created to do IP manipulation (both IPv4 and IPv6) using proper binary IP math (32-bit for IPv4 and 128-bit for IPv6), but reading and writing IP addresses as strings. I turned IPvX into a real application. See the **[IPvX.pdf](https://github.com/rmaupin/IPvX/raw/main/IPvX.pdf)** for a more complete explanation of the application.

Only the **IPvX.exe** (either **[IPvX.exe](https://github.com/rmaupin/IPvX/releases/download/v22.10.4.1-x86/IPvX.exe)** for Win32 or **[IPvX.exe](https://github.com/rmaupin/IPvX/releases/download/v22.10.4.1-x64/IPvX.exe)** for Win64]) and the **[IPvX.chm](https://github.com/rmaupin/IPvX/raw/main/IPvX.chm)** (help file for either version) are needed to run the application.

IPv4 addresses use the [common IPv4 dotted-decimal](https://en.wikipedia.org/wiki/Dot-decimal_notation#IPv4_address) notation (no leading zeroes in the octets).

IPv6 addresses are accepted in any of the three _[RFC 4291, Section 2.2. Text Representation of Addresses](https://www.rfc-editor.org/rfc/rfc4291.html#section-2.2)_ **conventional** formats (including expanded, compressed, expanded-mixed, and compressed-mixed in either or both upper- and lower-case), but they are only returned in the _[RFC 5952, A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952)_ **canonical** format (compressed and compressed-mixed for IPv4-mapped IPv6 addresses in only lower-case) because [RFC 5952](https://www.rfc-editor.org/rfc/rfc5952) says:

> As IPv6 deployment increases, there will be a dramatic increase in the need to use IPv6 addresses in text. While the IPv6 address architecture in [Section 2.2 of RFC 4291](https://www.rfc-editor.org/rfc/rfc4291.html#section-2.2) describes a flexible model for text representation of an IPv6 address, this flexibility has been causing problems for operators, system engineers, and users. This document defines a canonical textual representation format. It does not define a format for internal storage, such as within an application or database. ***It is expected that the canonical format will be followed by humans and systems when representing IPv6 addresses as text, but all implementations must accept and be able to handle any legitimate [RFC 4291](https://www.rfc-editor.org/rfc/rfc4291.html) format.***
