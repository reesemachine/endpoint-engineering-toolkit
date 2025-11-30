#!/usr/bin/env python3
"""
Lightweight FleetDM API client used for automation and reporting.
"""

import requests
from typing import Dict, Any, List

class FleetClient:
    def __init__(self, base_url: str, api_token: str, verify_tls: bool = True):
        self.base_url = base_url.rstrip("/")
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {api_token}",
            "Content-Type": "application/json"
        })
        self.session.verify = verify_tls

    def get_hosts(self) -> List[Dict[str, Any]]:
        """Return all hosts known to Fleet."""
        r = self.session.get(f"{self.base_url}/api/v1/fleet/hosts")
        r.raise_for_status()
        return r.json().get("hosts", [])

    def run_live_query(self, query: str, host_ids: List[int] = None) -> Dict[str, Any]:
        """
        Execute a live query across one or more hosts.
        For a production-ready version, you'd handle campaign IDs and polling.
        """
        payload: Dict[str, Any] = {"query": query}
        if host_ids:
            payload["selected"] = {"hosts": host_ids}

        r = self.session.post(f"{self.base_url}/api/v1/fleet/queries/run", json=payload)
        r.raise_for_status()
        return r.json()

if __name__ == "__main__":
    # Example usage
    client = FleetClient("https://fleet.yourcompany.com", "YOUR_API_TOKEN", verify_tls=True)
    hosts = client.get_hosts()
    print(f"Found {len(hosts)} hosts in Fleet.")
