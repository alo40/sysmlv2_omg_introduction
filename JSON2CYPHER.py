import json

with open("omg_single_example.json") as f:
    data = json.load(f)

cypher = []

# 1. Create all nodes
for e in data:
    props = []
    for key in ("@id", "@type", "declaredName", "memberName", "operator"):
        val = e.get(key)
        if val:
            field = "id" if key == "@id" else "type" if key == "@type" else key
            props.append(f'{field}:"{val}"')
    cypher.append(f'CREATE (:`Node` {{{", ".join(props)}}});')

# 2. Create relationships
rels = {
    "owningRelatedElement": "OWNS",
    "ownedRelationship": "OWNS_REL",
    "memberElement": "MEMBER_OF",
    "ownedRelatedElement": "OWNS_RELATED",
    "owningRelationship": "OWNING_REL",
    "general": "GENERAL",
    "specific": "SPECIFIC",
    "type": "TYPE_OF",
    "typedFeature": "TYPED_FEATURE",
}
for e in data:
    src_id = e["@id"]
    for k, rel in rels.items():
        if k in e:
            targets = e[k] if isinstance(e[k], list) else [e[k]]
            for t in targets:
                tid = t.get("@id")
                if tid:
                    cypher.append(
                        f'MATCH (a:Node {{id:"{src_id}"}}), (b:Node {{id:"{tid}"}}) '
                        f'CREATE (a)-[:{rel}]->(b);'
                    )

with open("omg_single_example.cypher", "w") as f:
    f.write("\n".join(cypher))
