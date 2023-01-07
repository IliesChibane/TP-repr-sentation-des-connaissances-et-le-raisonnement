import json

def get_label(reseau_semantique, node_id):
    label = [node["label"] for node in reseau_semantique["nodes"] if node["id"] == node_id]
    return " ,".join(label)

def heritage(reseau_semantique, name):
    the_end = False

    nodes = reseau_semantique["nodes"]
    edges = reseau_semantique["edges"]

    node = [node for node in nodes if node["label"] == name][0]
    legacy_edges = [edge["to"] for edge in edges if (edge["from"] == node["id"] and edge["label"] == "is_a")]
    legacy = []
    properties = []
    while not the_end:
        n = legacy_edges.pop()
        legacy.append(get_label(reseau_semantique, n))
        legacy_edges.extend([edge["to"] for edge in edges if (edge["from"] == n and edge["label"] == "is_a")])
        properties_nodes = [edge for edge in edges if (edge["from"] == n and edge["label"] != "is_a")]
        for pn in properties_nodes:
            properties.append(": ".join([pn["label"], get_label(reseau_semantique, pn["to"])]))
        if len(legacy_edges) == 0:
            the_end = True

    return legacy, properties