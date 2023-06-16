vpc_name = "HIPPA"
region = "us-east-2"
vpc_cidr = "10.10.0.0/16"
subnets = [
        # Public subnets
        {cidr_block: "10.10.102.0/24", az: "us-east-2a", name: "HIPPA-PUB-1a"},
        {cidr_block: "10.10.104.0/24", az: "us-east-2b", name: "HIPPA-PUB-1b"},
        {cidr_block: "10.10.106.0/24", az: "us-east-2c", name: "HIPPA-PUB-1c"},
        # UI subnets
        {cidr_block: "10.10.101.0/24", az: "us-east-2a", name: "HIPPA-UI-PRIVATE-1a"},
        {cidr_block: "10.10.103.0/24", az: "us-east-2b", name: "HIPPA-UI-PRIVATE-1b"},
        {cidr_block: "10.10.105.0/24", az: "us-east-2c", name: "HIPPA-UI-PRIVATE-1c"},
        # APP subnets
        {cidr_block: "10.10.111.0/24", az: "us-east-2a", name: "HIPPA-APP-PRIVATE-1a"},
        {cidr_block: "10.10.113.0/24", az: "us-east-2b", name: "HIPPA-APP-PRIVATE-1b"},
        {cidr_block: "10.10.115.0/24", az: "us-east-2c", name: "HIPPA-APP-PRIVATE-1c"},
        # DB subnets
        {cidr_block: "10.10.121.0/24", az: "us-east-2a", name: "HIPPA-DB-PRIVATE-1a"},
        {cidr_block: "10.10.123.0/24", az: "us-east-2b", name: "HIPPA-DB-PRIVATE-1b"},
        {cidr_block: "10.10.125.0/24", az: "us-east-2c", name: "HIPPA-DB-PRIVATE-1c"},
]

tags = {
    CreatedByTerraform : "True"
    Owner : "ITOP"
}

public_acls = {
    name = "PUB"
    ingress_rules = [
        { protocol : "tcp", rule_no : 100, action : "allow", cidr_block : "0.0.0.0/0", from_port : 80, to_port : 80 },
        { protocol : "tcp", rule_no : 101, action : "allow", cidr_block : "0.0.0.0/0", from_port : 443, to_port : 443 },
    ]
    egress_rules = [
        { protocol : "tcp", rule_no : 100, action : "allow", cidr_block : "0.0.0.0/0", from_port : 80, to_port : 80 },
        { protocol : "tcp", rule_no : 101, action : "allow", cidr_block : "0.0.0.0/0", from_port : 443, to_port : 443 },
    ]
}

security_groups = [
    {
        "name" : "APP SG"
        ingress_rules = [
            { "protocol" : "tcp", "cidr_blocks" : ["0.0.0.0/0"], "from_port" : 80, "to_port" : 80, "description" : "Allow 80" },
            { "protocol" : "tcp", "cidr_blocks" : ["0.0.0.0/0"], "from_port" : 443, "to_port" : 443, "description" : "Allow 443" }
        ]
        egress_rules = [
            { "protocol" : "tcp", "cidr_blocks" : ["0.0.0.0/0"], "from_port" : 80, "to_port" : 80, "description" : "Allow 80" },
            { "protocol" : "tcp", "cidr_blocks" : ["0.0.0.0/0"], "from_port" : 443, "to_port" : 443, "description" : "Allow 443" }
        ]
    },
    {
        "name" : "UI SG"
        ingress_rules = [
            { "protocol" : "tcp", "cidr_blocks" : ["0.0.0.0/0"], "from_port" : 80, "to_port" : 80, "description" : "Allow 80" },
            { "protocol" : "tcp", "cidr_blocks" : ["0.0.0.0/0"], "from_port" : 443, "to_port" : 443, "description" : "Allow 443" }
        ]
        egress_rules = [
            { "protocol" : "tcp", "cidr_blocks" : ["0.0.0.0/0"], "from_port" : 80, "to_port" : 80, "description" : "Allow 80" },
            { "protocol" : "tcp", "cidr_blocks" : ["0.0.0.0/0"], "from_port" : 443, "to_port" : 443, "description" : "Allow 443" }
        ]
    }
]