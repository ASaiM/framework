#!/usr/bin/env python

"""
Read metaphaln output summarizing taxonomic distribution and format in PhyloXML format

usage: %prog metaphlan.txt phylo.xml
"""

import sys

# Metaphlan output looks like:
#   k__Bacteria   99.07618
#   k__Archaea  0.92382
#   k__Bacteria|p__Proteobacteria   82.50732
#   k__Bacteria|p__Proteobacteria|c__Gammaproteobacteria    81.64905

rank_map = { 'k__': 'kingdom', 'p__': 'phylum', 'c__': 'class', 'o__': 'order', 'f__': 'family', 'g__': 'genus', 's__': 'species' }

class Node( object ):
    """Node in a taxonomy"""
    def __init__( self, rank=None, name=None ):
        self.rank = rank
        self.name = name
        self.value = None
        self.children = dict()
    @staticmethod
    def from_metaphlan_file( file ):
        """
        Build tree from metaphlan output
        """
        root = Node()
        for line in file:
            taxa, abundance = line.split()
            parts = taxa.split( "|" )
            root.add( parts, abundance )
        return root
    def add( self, parts, value ):
        """
        Parts is a list of node names, recursively add nodes until we reach
        the last part, and then attach the value to that node.
        """
        if len( parts ) == 0:
            self.value = value
        else:
            next_part = parts.pop(0)
            rank = rank_map[ next_part[:3] ]
            name = next_part[3:]
            if name not in self.children:
                self.children[name] = Node( rank, name )
            self.children[name].add( parts, value )
    def __str__( self ):
        if self.children:   
            return "(" + ",".join( str( child ) for child in self.children.itervalues() ) + "):" + self.name
        else:
            return self.name
    def to_phyloxml( self, out ):
        print >>out, "<clade>"
        if self.name:
            print >>out, "<name>%s</name>" % self.name
            print >>out, "<taxonomy><scientific_name>%s</scientific_name><rank>%s</rank></taxonomy>" % ( self.name, self.rank )
        if self.value:
            print >>out, "<property datatype='xsd:float' ref='metaphlan:abundance' applies_to='node'>%s</property>" % self.value
            ## print >>out, "<confidence type='abundance'>%s</confidence>" % self.value
        for child in self.children.itervalues():
            child.to_phyloxml( out )
        print >>out, "</clade>"

out = open( sys.argv[2], 'w' )

print >>out, '<phyloxml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.phyloxml.org" xsi:schemaLocation="http://www.phyloxml.org http://www.phyloxml.org/1.10/phyloxml.xsd">'
print >>out, '<phylogeny rooted="true">'

Node.from_metaphlan_file( open( sys.argv[1] ) ).to_phyloxml( out )

print >>out, '</phylogeny>'
print >>out, '</phyloxml>'
