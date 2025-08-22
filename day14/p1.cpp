#include <iostream>
#include <iterator>
#include <regex>
#include <string>
#include <vector>
#include <stdio.h>

constexpr long TIME = 100;
constexpr long WIDE = 101;
constexpr long HEIGHT = 103;
// constexpr long WIDE = 11;
// constexpr long HEIGHT = 7;

int main()
{
    typedef std::istreambuf_iterator<char> istream;

    std::string input((istream(std::cin)), istream());

    // std::cout << input;

    std::regex pat("p=(-?\\d+),(-?\\d+)\\s*v=(-?\\d+),(-?\\d+)",
                          std::regex_constants::ECMAScript);
    if (std::regex_search(input, pat))
        std::cout << "Text contains the phrase 'regular expressions'\n";

    auto begin = std::sregex_iterator(input.begin(), input.end(), pat);
    auto end = std::sregex_iterator();
    std::cout << "Found "
              << std::distance(begin, end)
              << " words\n";

    std::vector<std::tuple<long,long,long,long>> lines;

    for (std::sregex_iterator i = begin; i != end; ++i)
    {
        std::smatch match = *i;
        auto Px = std::stol(match[1].str());
        auto Py = std::stol(match[2].str());
        auto Vx = std::stol(match[3].str());
        auto Vy = std::stol(match[4].str());
        lines.emplace_back(Px,Py,Vx,Vy);
    }
    std::cout << "positions:\n";
    for (auto sd : lines) {
        std::cout << "output: " << std::get<0>(sd) << " " << std::get<1>(sd) << '\n';
    }
    // now to doing stuff:::...```''''

    auto get_future_scalar_pos = [](long p, long v, long width) {
        long biggy = p + v*TIME;
        if (biggy < 0) {
            biggy += width * (((biggy*(-1))/width)+1);
        }
        return biggy % width;
    };

    long count[] = {0,0,0,0};

    for (auto rob : lines) {
        auto new_x = get_future_scalar_pos(std::get<0>(rob), std::get<2>(rob), WIDE);
        auto new_y = get_future_scalar_pos(std::get<1>(rob), std::get<3>(rob), HEIGHT);
        std::cout << "x : " << new_x << " y : " << new_y << "\n";

        // get quadrant
        if (!(new_x == (WIDE/2) || new_y == (HEIGHT/2))) {
            // not in da middle
            auto s = new_x < (WIDE/2);
            auto t = new_y < (HEIGHT/2);
            auto idx = s + (t<<1);
            count[idx]++;
        }
    }
    long res = count[0]*count[1]*count[2]*count[3];
    std::cout << "res: " << res << '\n';

    long sec = 0;
    while (true) {
        sec++;
        int16_t mat[HEIGHT][WIDE];
        for (int i = 0 ; i < HEIGHT; ++i) 
            for (int j = 0; j < WIDE; ++j) 
                mat[i][j] = 0;
        // move each one along one step
        for (auto& rob: lines) {
            auto& x = std::get<0>(rob);
            auto& y = std::get<1>(rob);
            auto vx = std::get<2>(rob);
            auto vy = std::get<3>(rob);
            x += vx;
            y += vy;
            if (x < 0) x += WIDE;
            if (y < 0) y += HEIGHT;
            x %= WIDE;
            y %= HEIGHT;
            ++mat[y][x];
        }
        // display it
        std::cout << "After " << sec << " secs:\n";
        for (int i = 0; i < HEIGHT; ++i) {
            for (int j = 0; j < WIDE; ++j) {
                auto num = mat[i][j];
                char d = '0' + num;
                if (num > 9) {
                    d = 'X';
                }
                if (d == '0') d = ' ';
                printf("%c", d);
            }
            printf("\n");
        }
        // search for stuff? 
        for (int i = 0; i < HEIGHT; ++i) {
            long running = 0;
            for (int j = 0; j < WIDE; ++j) {
                auto num = mat[i][j];
                if (num > 0) ++running;
                else running = 0;
                if (running > 8) {
                    std::cout << "DONE WE FOUND IT! at " << sec << " also for p1 we got: " << res << " \n";
                    exit(1);
                }
            }
            printf("\n");
        }
    }
}
