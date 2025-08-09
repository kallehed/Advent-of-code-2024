run with `dotnet run --project . < ./data.txt`



example code:
```

var names = new[] { "<name>", "Felipe", "Emillia" };
foreach (var name in names)
{
    Console.WriteLine($"Hello {name.ToUpper()}!");
}



var dict = new Dictionary<string, int>();
dict["first"] = 10;
dict["second"] = 20;
dict["third"] = 30;

Console.WriteLine(string.Join("; ", dict.Select(entry => $"{entry.Key}: {entry.Value}")));


// references:
public ref Book GetBookByTitle(string title)
    {
        for (int ctr = 0; ctr < books.Length; ctr++)
        {
            if (title == books[ctr].Title)
                return ref books[ctr];
        }
        return ref nobook;
    }

// enumerable:
IEnumerable<int> ProduceEvenNumbers(int upto)
{
    for (int i = 0; i <= upto; i += 2)
    {
        yield return i;
    }
}


// ref iterate
Span<int> storage = stackalloc int[10];
int num = 0;
foreach (ref int item in storage)
{
    item = num++;
}
foreach (ref readonly var item in storage)
{
    Console.Write($"{item} ");
}


```