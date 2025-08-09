
public class Asd {

    public static void Main()
    {
        Console.WriteLine("asd");

        var matrix = new List<List<int>>();

        string line;
        while ((line = Console.ReadLine()) != null)
        {
            matrix.Add(new List<int>());
            foreach (var c in line)
            {
                matrix[matrix.Count - 1].Add(c - '0');
            }
        }
        Console.WriteLine($"asd {matrix.ToString()}");
        matrix.ForEach(x => Console.WriteLine(String.Join(',', x)));

        // for each spot, keep a score, how many 9's can be reached from there. Start iterating from 9's,
        // as they are 1
        int rows = matrix.Count;
        int cols = matrix[0].Count;

        var points = new int[rows, cols];

        var been_there = new bool[rows, cols];

        void hike (int i, int j, int prevh)
        {
            if (i < 0 || j < 0 || i >= rows || j >= cols) return;
            if (matrix[i][j] != prevh - 1) return;
            if (been_there[i, j]) return;
            been_there[i, j] = true;
            //if (points[i, j] != 0) return; // have not reached here before

            points[i, j] += 1;
            // look for belowers
            int h = matrix[i][j];
            hike(i+1, j, h);
            hike(i-1, j, h);
            hike(i, j+1, h);
            hike(i, j-1, h);
        };

        for (int i = 0; i < rows; ++i)
        {
            for (int j = 0; j < cols; ++j)
            {
                been_there = new bool[rows, cols];
                hike(i, j, 10);
            }
        }
        for (int i = 0; i < rows; ++i)
        {
            for (int j = 0; j < cols; ++j)
            {
                Console.Write($"{points[i,j]},");
            }
            Console.WriteLine();
        }
        int total = 0;
        for (int i = 0; i < rows; ++i)
        {
            for (int j = 0; j < cols; ++j)
            {
                if (matrix[i][j] == 0)
                {
                    total += points[i, j];
                }
            }
        }
        Console.WriteLine($"PART1 {total}");

        points = new int[rows, cols];

        void hike2 (int i, int j, int prevh)
        {
            if (i < 0 || j < 0 || i >= rows || j >= cols) return;
            if (matrix[i][j] != prevh - 1) return;
            //if (points[i, j] != 0) return; // have not reached here before

            points[i, j] += 1;
            // look for belowers
            int h = matrix[i][j];
            hike2(i+1, j, h);
            hike2(i-1, j, h);
            hike2(i, j+1, h);
            hike2(i, j-1, h);
        };

        for (int i = 0; i < cols; ++i)
            for (int j = 0; j < rows; ++j)
                hike2(i, j, 10);
        for (int i = 0; i < cols; ++i)
        {
            for (int j = 0; j < rows; ++j)
                Console.Write($"{points[i,j]},");
            Console.WriteLine();
        }
        total = 0;
        for (int i = 0; i < cols; ++i)
            for (int j = 0; j < rows; ++j)
                if (matrix[i][j] == 0)
                    total += points[i, j];
        Console.WriteLine($"PART2 {total}");

    }
}

