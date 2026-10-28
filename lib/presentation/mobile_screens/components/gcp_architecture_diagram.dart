import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../../providers/color_provider.dart';

class GcpArchitectureDiagram extends StatefulWidget {
  const GcpArchitectureDiagram({super.key});

  @override
  State<GcpArchitectureDiagram> createState() => _GcpArchitectureDiagramState();
}

class _GcpArchitectureDiagramState extends State<GcpArchitectureDiagram>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int? _selectedNodeIndex;

  final List<GcpNodeInfo> _nodes = [
    GcpNodeInfo(
      id: "dns",
      title: "Google Cloud DNS",
      subtitle: "Global Anycast DNS & Domain Routing",
      category: "Edge & Networking",
      icon: Icons.public_rounded,
      iconColor: Color(0xFF4285F4),
      status: "Active (100% SLA)",
      description:
          "Authoritative DNS service translating domain requests with low latency across Google's worldwide fiber network.",
      cliSnippet: "gcloud dns record-sets transaction start --zone=portfolio-zone\ngcloud dns record-sets transaction add 34.120.x.x --name=portfolio.com. --ttl=300 --type=A",
      specs: [
        {"Latency": "< 25ms globally"},
        {"DNSSEC": "Enabled"},
        {"Type": "A / CNAME Anycast"},
      ],
    ),
    GcpNodeInfo(
      id: "ssl_lb",
      title: "HTTP(S) Load Balancer",
      subtitle: "Google-Managed SSL & HTTP->HTTPS Redirect",
      category: "Traffic Management",
      icon: Icons.shield_rounded,
      iconColor: Color(0xFF34A853),
      status: "Healthy • Port 80 & 443",
      description:
          "Global External Application Load Balancer terminating SSL with auto-renewing Google-managed certificates and redirecting insecure HTTP to HTTPS.",
      cliSnippet: "gcloud compute ssl-certificates create portfolio-cert --domains=portfolio.com\ngcloud compute url-maps create lb-url-map --default-service=backend-service",
      specs: [
        {"SSL Cert": "Google-Managed (RSA 2048)"},
        {"Redirection": "HTTP 301 to HTTPS"},
        {"Protocol": "HTTP/2 & IPv6 Ready"},
      ],
    ),
    GcpNodeInfo(
      id: "firewall",
      title: "VPC Firewall & IAM",
      subtitle: "Zero-Trust Virtual Private Cloud Security",
      category: "Network Security",
      icon: Icons.lock_outline_rounded,
      iconColor: Color(0xFFEA4335),
      status: "Guarded • Strict Egress/Ingress",
      description:
          "VPC firewall policies allowing ingress only from Google Cloud Load Balancers and restricted Cloud Shell SSH bastion keys.",
      cliSnippet: "gcloud compute firewall-rules create allow-lb-ingress \\\n  --network=default \\\n  --allow=tcp:80,tcp:443 \\\n  --source-ranges=130.211.0.0/22,35.191.0.0/16",
      specs: [
        {"Ingress Source": "GCP Health Check & LB CIDRs"},
        {"SSH Bastion": "IAP (Identity-Aware Proxy)"},
        {"IAM Roles": "Least Privilege Principle"},
      ],
    ),
    GcpNodeInfo(
      id: "mig",
      title: "Compute Engine MIG",
      subtitle: "Managed Instance Group (Autoscaling VMs)",
      category: "Compute & Workloads",
      icon: Icons.developer_board_rounded,
      iconColor: Color(0xFFFBBC05),
      status: "Autoscaling (2 - 6 Instances)",
      description:
          "High-availability cluster of Nginx web servers provisioned inside a Managed Instance Group with health checks and auto-healing.",
      cliSnippet: "gcloud compute instance-groups managed create web-mig \\\n  --base-instance-name=web-vm \\\n  --template=web-template-v2 \\\n  --size=2 \\\n  --zone=us-central1-a",
      specs: [
        {"Machine Type": "e2-medium (2 vCPU, 4GB RAM)"},
        {"Auto-healing": "HTTP Health Check /healthz"},
        {"Web Server": "Nginx Reverse Proxy"},
      ],
    ),
    GcpNodeInfo(
      id: "gcs",
      title: "Cloud Storage (GCS)",
      subtitle: "Asset Hosting & High-Speed Media CDN",
      category: "Storage & CDN",
      icon: Icons.cloud_done_rounded,
      iconColor: Color(0xFF4285F4),
      status: "Multi-Regional Bucket",
      description:
          "Object storage bucket serving cached web assets, certificates, and release builds with 99.99% durability and automated versioning.",
      cliSnippet: "gcloud storage buckets create gs://portfolio-web-assets --location=US\ngcloud storage buckets add-iam-policy-binding gs://portfolio-web-assets --member=allUsers --role=roles/storage.objectViewer",
      specs: [
        {"Storage Class": "Standard Multi-Regional"},
        {"CORS Policy": "Enabled for Web"},
        {"Encryption": "Google-Managed Keys"},
      ],
    ),
    GcpNodeInfo(
      id: "automation",
      title: "gcloud CLI & Automation",
      subtitle: "Cloud Shell & Automated Server Scripts",
      category: "DevOps & Provisioning",
      icon: Icons.terminal_rounded,
      iconColor: Color(0xFF00ACC1),
      status: "CI/CD Provisioned",
      description:
          "Automated provisioning scripts executed via Google Cloud Shell, gcloud SDK, and SSH for seamless server configuration and zero downtime deployments.",
      cliSnippet: "gcloud compute ssh web-vm-1 --command=\"sudo systemctl reload nginx && git pull origin main\"",
      specs: [
        {"SDK": "gcloud CLI v480+"},
        {"Tooling": "Cloud Shell, SSH Keys, Nginx"},
        {"Workflow": "Automated Deployment Pipeline"},
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _selectedNodeIndex = 1; // Default to Load Balancer
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedNode = _selectedNodeIndex != null ? _nodes[_selectedNodeIndex!] : null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131A24) : const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeColor.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A2332) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4285F4).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    SimpleIcons.googlecloud,
                    color: Color(0xFF4285F4),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "GCP Architecture Topology",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Interactive live cloud infrastructure map",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "LIVE",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Visual Flow Diagram
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Internet Client Node
                _buildTrafficOriginNode(themeColor, isDark),

                // Animated Traffic Stream
                _buildTrafficStreamIndicator(themeColor),

                // Layer 1: DNS
                _buildNodeCard(0, themeColor, isDark),

                // Animated Connector
                _buildTrafficStreamIndicator(themeColor),

                // Layer 2: SSL & Load Balancer
                _buildNodeCard(1, themeColor, isDark),

                // Animated Connector
                _buildTrafficStreamIndicator(themeColor),

                // Layer 3: VPC Firewall
                _buildNodeCard(2, themeColor, isDark),

                // Animated Connector
                _buildTrafficStreamIndicator(themeColor),

                // Layer 4: Compute Engine MIG & Cloud Storage (Side by Side)
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildNodeCard(3, themeColor, isDark, compact: true),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: _buildNodeCard(4, themeColor, isDark, compact: true),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Layer 5: Automation & Tooling
                _buildNodeCard(5, themeColor, isDark, compact: true),
              ],
            ),
          ),

          // Detailed Inspector Drawer for Selected Node
          if (selectedNode != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2838) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selectedNode.iconColor.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: selectedNode.iconColor.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: selectedNode.iconColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          selectedNode.icon,
                          color: selectedNode.iconColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedNode.title,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              selectedNode.subtitle,
                              style: TextStyle(
                                fontSize: 11,
                                color: selectedNode.iconColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          selectedNode.status,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text(
                    selectedNode.description,
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontFamily: GoogleFonts.rubik().fontFamily,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Specs Chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (var spec in selectedNode.specs)
                        for (var entry in spec.entries)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withOpacity(0.25)
                                  : Colors.grey.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${entry.key}: ",
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white60 : Colors.black54,
                                    ),
                                  ),
                                  TextSpan(
                                    text: entry.value,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // CLI snippet box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F141C),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white12,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.code_rounded, size: 12, color: Colors.cyanAccent),
                            const SizedBox(width: 4),
                            Text(
                              "gcloud CLI / Provisioning Script",
                              style: GoogleFonts.firaCode(
                                fontSize: 10,
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          selectedNode.cliSnippet,
                          style: GoogleFonts.firaCode(
                            fontSize: 10,
                            color: Colors.greenAccent.shade200,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrafficOriginNode(Color themeColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2838) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeColor.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language_rounded, size: 14, color: Colors.cyanAccent),
          SizedBox(width: 6),
          Text(
            "Global Visitors (Internet Traffic)",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrafficStreamIndicator(Color themeColor) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            children: [
              Container(
                width: 2,
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeColor.withOpacity(0.2),
                      themeColor.withOpacity(0.5 + (_pulseController.value * 0.5)),
                      themeColor.withOpacity(0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 12,
                color: themeColor.withOpacity(0.6 + (_pulseController.value * 0.4)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNodeCard(
    int index,
    Color themeColor,
    bool isDark, {
    bool compact = false,
  }) {
    final node = _nodes[index];
    final isSelected = _selectedNodeIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNodeIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 12,
          vertical: compact ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? node.iconColor.withOpacity(isDark ? 0.2 : 0.1)
              : (isDark ? const Color(0xFF1B2330) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? node.iconColor : (isDark ? Colors.white12 : Colors.black12),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: node.iconColor.withOpacity(0.25),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: node.iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                node.icon,
                color: node.iconColor,
                size: compact ? 16 : 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    node.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 11.5 : 12.5,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? node.iconColor : null,
                    ),
                  ),
                  Text(
                    node.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 9.5 : 10.5,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 14,
              color: isSelected ? node.iconColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class GcpNodeInfo {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color iconColor;
  final String status;
  final String description;
  final String cliSnippet;
  final List<Map<String, String>> specs;

  GcpNodeInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.status,
    required this.description,
    required this.cliSnippet,
    required this.specs,
  });
}
