    
%%% Read input images (drawing and scribbles):

pic = double(imread('drawing.png'));
usr = double(imread('scribbles.png'));

fig=1;     figure(fig); imagesc(pic/255); axis image; title('Drawing')
fig=fig+1; figure(fig); imagesc(usr/255); axis image; title('Scribbles')

%%% Setting scale for edge capacities between two white pixels:

EK = 2000;

%%% Setting scale for edge capacities that correspond to soft scribbles:

SK = 200;

%%% Getting drawing dimensions:

w = size(pic, 1);
h = size(pic, 2);

%%% Setting indices of auxillary source "S" and sink "T" terminal vertices:

S = w * h + 1;
T = w * h + 2;

%%% Prepare an array "id" that assign unique index to each pixel (x,y) and 
%%% inverted arrays "idx" and "idy" that for the given vertex index returns 
%%% x and y coordiantes of its corresponding pixel [1.5 point]:

vid = 1; % vertex index

% TODO (DONE !)
id = zeros(w, h);
idx = zeros(w * h, 1);
idy = zeros(w * h, 1);
for x=1:w
    for y=1:h
        id(x, y) = vid;
        idx(vid) = x;
        idy(vid) = y; 
        vid = vid + 1;
    end
end

%%% Setup directed edges going from the source terminal "S" to all pixels 
%%% and from all pixels to the sink terminal "T" and set their capacities
%%% according to scribbles stored in "usr" (use "SK") [3 points]:

eid = 1; % edge index

numEdges = 2 * w * h; % Each pixel has two edges, to S and T
source = zeros(numEdges, 1);
target = zeros(numEdges, 1);
capacity = zeros(numEdges, 1);
% Graph edges are specified using three index arrays:
%     "source(eid)" = index of source (from) graph vertex
%     "target(eid)" = index of target (to) graph vertex
%     "capacity(eid)" = edge capacity
% TODO
for x=1:w
    for y=1:h
        pixelIndex = id(x, y);
        
        % Edge from pixel to source S
        source(eid) = S;
        target(eid) = pixelIndex;
        if usr(x, y, 1) == 255
           capacity(eid) = SK;
        else
           capacity(eid) = 0;
        end  
        eid = eid + 1; 
    end 
end

for x=1:w
    for y=1:h
        pixelIndex = id(x, y);
        
        % Edge from pixel to sink T
        source(eid) = pixelIndex;
        target(eid) = T;
        if usr(x, y, 1) == 14
           capacity(eid) = SK;
       else
           capacity(eid) = 0;
       end  
        eid = eid + 1; 
    end 
end

%%% Setup capacities of undirected edges between neighbour pixels 
%%% (undirected edge = two directed edges in opposite direction with 
%%% the same capacity). As a capacity use "EK" scaled in proportion to 
%%% pixel's intensity. You can use gamma correction to improve contrast 
%%% between white and dark pixels (remember that edge capacity between 
%%% pixels shouldn't be equal to zero) [4 points]:


% TODO
gammaValue = 6;
minCapacity = 1;  % Minimum capacity to avoid zero capacity

pic = pic / 255.0;
for x=1:w
    for y=1:h
        if x < w && y < h
            source(eid:eid+3) = [id(x,y), id(x,y), id(x + 1,y), id(x,y + 1)];
            target(eid:eid+3) = [id(x + 1,y), id(x,y + 1), id(x,y), id(x,y)];

            cap1 = 1 + min(pic(x,y), pic(x + 1,y))^gammaValue * EK;
            cap2 = 1 + min(pic(x,y), pic(x,y + 1))^gammaValue * EK;
            capacity(eid:eid+3) = [cap1, cap2, cap1, cap2];

            eid = eid+4; 
        elseif x == w && y < h
            source(eid:eid+1) = [id(x,y), id(x,y + 1)];
            target(eid:eid+1) = [id(x,y + 1), id(x,y)];
           
            cap1 = 1 + min(pic(x,y), pic(x,y + 1))^gammaValue * EK;
            capacity(eid:eid+1) = [cap1, cap1];
            eid = eid+2;

        elseif x < w && y == h
            source(eid:eid+1) = [id(x + 1,y), id(x,y)];
            target(eid:eid+1) = [id(x,y), id(x + 1,y)];
           
            cap1 = 1 + min(pic(x,y), pic(x + 1,y))^gammaValue * EK;
            capacity(eid:eid+1) = [cap1, cap1];
            eid = eid+2;
        end

    end 
end

%%% Construct a directed graph "G" and solve for maximum flow between 
%%% source "S" and sink "T" terminal vertices. Use "source", "target", 
%%% and "capacity" arrays prepared in previous steps:

G = digraph(source, target, capacity);
% plot(G);

[MF,GF,CS,CT] = maxflow(G,S,T);

%%% Get indices of pixels labelled as belonging to terminal "T" stored 
%%% in the array "CT" and colorize them by multiplying their original 
%%% intensity with the color components of the green color. Use "idx"
%%% and "idy" to lookup pixel coordiantes [1.5 points]: 

out = pic * 255; % copy the input drawing to the output
 
col(1) = 14; % setup green color RGB values
col(2) = 138;
col(3) = 8;

% TODO
for id=1:size(CT) - 2
    % Get the pixel index from CT
    pixelIndex = CT(id);

    % Find the corresponding x, y coordinates
    x = idx(pixelIndex);
    y = idy(pixelIndex);

    % Colorize the pixel
    out(x, y, 1) = out(x, y, 1) * col(1) / 255;
    out(x, y, 2) = out(x, y, 2) * col(2) / 255;
    out(x, y, 3) = out(x, y, 3) * col(3) / 255;
end

%%% Show the resulting colorized image:

fig=fig+1; figure(fig); imagesc(out/255); axis image; title('Output')
