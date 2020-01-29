extends ImmediateGeometry

const CELL_SIZE = 8
const GRID_SIZE = 64

func _ready():
	for cell in range(0, GRID_SIZE, CELL_SIZE):
		self.begin(PrimitiveMesh.PRIMITIVE_LINES, null)
		self.add_vertex(Vector3(cell, 0, 0))
		self.add_vertex(Vector3(cell, 0, GRID_SIZE-1))
		self.end()
		self.begin(PrimitiveMesh.PRIMITIVE_LINES, null)
		self.add_vertex(Vector3(0, 0, cell))
		self.add_vertex(Vector3(GRID_SIZE-1, 0, cell))
		self.end()
